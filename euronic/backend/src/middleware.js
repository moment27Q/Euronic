import { verifyAccessToken } from "./auth.js";

export function requireAuth(req, res, next) {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token) {
    return res.status(401).json({ message: "Token requerido" });
  }

  try {
    req.user = verifyAccessToken(token);
    req.rawToken = token;
    next();
  } catch {
    return res.status(401).json({ message: "Token invalido o expirado" });
  }
}
