import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import bcrypt from "bcryptjs";
import { pool } from "./db.js";
import { createAccessToken, hashToken } from "./auth.js";
import { requireAuth } from "./middleware.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "*",
  })
);

app.get("/health", async (_req, res) => {
  const result = await pool.query("SELECT NOW() as now");
  res.json({ ok: true, dbTime: result.rows[0].now });
});

app.get("/plans", async (_req, res) => {
  const result = await pool.query(
    `SELECT id, code, name, description, price_monthly, price_yearly, max_projects, max_users
     FROM plan
     WHERE is_active = TRUE
     ORDER BY price_monthly ASC`
  );
  res.json(result.rows);
});

app.post("/auth/register", async (req, res) => {
  const { email, password, fullName } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: "Email y password son obligatorios" });
  }

  const passwordHash = await bcrypt.hash(password, 12);
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const userResult = await client.query(
      `INSERT INTO app_user (email, password_hash, full_name)
       VALUES ($1, $2, $3)
       RETURNING id, email, full_name, created_at`,
      [email.toLowerCase().trim(), passwordHash, fullName || null]
    );
    const user = userResult.rows[0];

    await client.query(
      `INSERT INTO user_subscription (user_id, plan_id, status)
       SELECT $1, id, 'active'
       FROM plan
       WHERE code = 'free'`,
      [user.id]
    );
    await client.query("COMMIT");
    return res.status(201).json({ user });
  } catch (error) {
    await client.query("ROLLBACK");
    if (error.code === "23505") {
      return res.status(409).json({ message: "El email ya esta registrado" });
    }
    return res.status(500).json({ message: "No se pudo crear la cuenta" });
  } finally {
    client.release();
  }
});

app.post("/auth/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: "Email y password son obligatorios" });
  }

  const userResult = await pool.query(
    `SELECT id, email, full_name, password_hash, is_active
     FROM app_user
     WHERE email = $1`,
    [email.toLowerCase().trim()]
  );
  if (!userResult.rowCount) {
    return res.status(401).json({ message: "Credenciales invalidas" });
  }

  const user = userResult.rows[0];
  if (!user.is_active) {
    return res.status(403).json({ message: "Usuario inactivo" });
  }

  const isValid = await bcrypt.compare(password, user.password_hash);
  if (!isValid) {
    return res.status(401).json({ message: "Credenciales invalidas" });
  }

  const token = createAccessToken({ sub: user.id, email: user.email });
  const tokenDigest = hashToken(token);

  await pool.query(
    `INSERT INTO auth_session (user_id, token_hash, ip_address, user_agent, expires_at)
     VALUES ($1, $2, $3, $4, NOW() + interval '7 days')`,
    [user.id, tokenDigest, req.ip || null, req.headers["user-agent"] || null]
  );

  return res.json({
    token,
    user: {
      id: user.id,
      email: user.email,
      fullName: user.full_name,
    },
  });
});

app.get("/me", requireAuth, async (req, res) => {
  const result = await pool.query(
    `SELECT u.id, u.email, u.full_name, u.created_at, p.code AS plan_code, p.name AS plan_name
     FROM app_user u
     LEFT JOIN user_subscription s ON s.user_id = u.id AND s.status = 'active'
     LEFT JOIN plan p ON p.id = s.plan_id
     WHERE u.id = $1
     LIMIT 1`,
    [req.user.sub]
  );

  if (!result.rowCount) {
    return res.status(404).json({ message: "Usuario no encontrado" });
  }

  return res.json(result.rows[0]);
});

app.post("/auth/logout", requireAuth, async (req, res) => {
  const tokenDigest = hashToken(req.rawToken);
  await pool.query(
    `UPDATE auth_session
     SET revoked_at = NOW()
     WHERE token_hash = $1`,
    [tokenDigest]
  );
  return res.json({ ok: true });
});

app.post("/subscriptions/change-plan", requireAuth, async (req, res) => {
  const { planCode } = req.body;
  if (!planCode) {
    return res.status(400).json({ message: "planCode es obligatorio" });
  }

  const planResult = await pool.query(
    "SELECT id FROM plan WHERE code = $1 AND is_active = TRUE",
    [planCode]
  );
  if (!planResult.rowCount) {
    return res.status(404).json({ message: "Plan no encontrado" });
  }

  const planId = planResult.rows[0].id;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    await client.query(
      "UPDATE user_subscription SET status = 'canceled', ends_at = NOW() WHERE user_id = $1 AND status = 'active'",
      [req.user.sub]
    );
    await client.query(
      "INSERT INTO user_subscription (user_id, plan_id, status) VALUES ($1, $2, 'active')",
      [req.user.sub, planId]
    );
    await client.query("COMMIT");
    return res.json({ ok: true });
  } catch {
    await client.query("ROLLBACK");
    return res.status(500).json({ message: "No se pudo cambiar el plan" });
  } finally {
    client.release();
  }
});

const port = Number(process.env.PORT || 4000);
app.listen(port, () => {
  console.log(`Euronic API running on http://localhost:${port}`);
});
