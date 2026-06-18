import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import 'services/auth_service.dart';
import 'services/api_config.dart';

void main() {
  runApp(const EuronicApp());
}

const _kBgDark  = Color(0xFF06091A);
const _kBgBlue  = Color(0xFF1706A8);
const _kBgLight = Color(0xFFBFC2EE);
const _kPurple  = Color(0xFF5B3FD4);
const _kBtnDark = Color(0xFF0E0E0E);
const _kAmber   = Color(0xFFE1BB35);
const _kCardBg  = Color(0xFFFFFFFF);
const _kPageBg  = Color(0xFFF3F3F3);

class EuronicApp extends StatelessWidget {
  const EuronicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euronic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: _kPageBg,
      ),
      home: const WelcomePage(),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA 1 – Welcome / Licencia
// ─────────────────────────────────────────────
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _licenseCode = '';

  Future<void> _scanQrCode() async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const QrScannerPage()),
    );
    if (scannedCode == null || scannedCode.isEmpty) return;
    final normalized = scannedCode
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();
    if (!mounted) return;
    setState(() {
      _licenseCode =
          normalized.length > 5 ? normalized.substring(0, 5) : normalized;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR escaneado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.42, 1.0],
            colors: [_kBgDark, _kBgBlue, _kBgLight],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 36, 24, 28),
                  child: Text(
                    '"Rompe\nfronteras\ncon cada\npalabra"',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _TranslatorIllustration(),
                ),
                const SizedBox(height: 28),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    'Esanea el Codigo QR para obtener tu licencia\nlibre, o create una cuenta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _LicenseCodeInputs(code: _licenseCode),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _DarkPillButton(
                          label: 'Activar Licencia',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      _DarkPillIconButton(
                        icon: Icons.qr_code_scanner_rounded,
                        onTap: _scanQrCode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _DarkPillButton(
                    label: 'Iniciar Sesión',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const LoginPage()),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      child: const Text('f',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87)),
                    ),
                    const SizedBox(width: 18),
                    _SocialButton(
                      child: const Icon(Icons.apple,
                          size: 22, color: Colors.black87),
                    ),
                    const SizedBox(width: 18),
                    _SocialButton(
                      child: const Text('G+',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87)),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ilustración decorativa
// ─────────────────────────────────────────────
class _TranslatorIllustration extends StatelessWidget {
  const _TranslatorIllustration();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OutlinePill(
          height: 76,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _PurpleBall(
                  icon: Icons.record_voice_over_rounded, diameter: 62),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _OutlineCircle(diameter: 76),
            const SizedBox(width: 10),
            _OutlineCircle(diameter: 76),
            const SizedBox(width: 10),
            Expanded(child: _OutlinePill(height: 76)),
          ],
        ),
        const SizedBox(height: 10),
        _OutlinePill(
          height: 76,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PurpleBall(icon: Icons.translate_rounded, diameter: 62),
                _PurpleBall(icon: Icons.mic_rounded, diameter: 62),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({required this.height, this.child});
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: child,
    );
  }
}

class _OutlineCircle extends StatelessWidget {
  const _OutlineCircle({required this.diameter});
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _PurpleBall extends StatelessWidget {
  const _PurpleBall({required this.icon, required this.diameter});
  final IconData icon;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: _kPurple),
      child: Icon(icon, color: Colors.white, size: diameter * 0.44),
    );
  }
}

// ─────────────────────────────────────────────
// Widgets comunes
// ─────────────────────────────────────────────
class _DarkPillButton extends StatelessWidget {
  const _DarkPillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBtnDark,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _DarkPillIconButton extends StatelessWidget {
  const _DarkPillIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 64,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBtnDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Icon(icon, size: 26),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black45, width: 1.5),
        color: Colors.white.withAlpha(220),
      ),
      child: Center(child: child),
    );
  }
}

class _LicenseCodeInputs extends StatelessWidget {
  const _LicenseCodeInputs({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (i) {
        final char = i < code.length ? code[i] : '';
        return Container(
          height: 66,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white60, width: 2),
            color: Colors.white.withAlpha(20),
          ),
          child: Text(char,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700)),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA 2 – Login / Crear cuenta
// ─────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isLoginTab = true;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _fullNameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa correo y contraseña')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      if (_isLoginTab) {
        await _authService.login(email: email, password: password);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => HomeDashboardPage(
              userName: fullName.isEmpty ? email.split('@').first : fullName,
            ),
          ),
        );
      } else {
        await _authService.register(
          email: email,
          password: password,
          fullName: fullName.isEmpty ? null : fullName,
        );
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => HomeDashboardPage(
              userName: fullName.isEmpty ? email.split('@').first : fullName,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
            colors: [Color(0xFFCBCAF8), Color(0xFFE4E3FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Botón cerrar ──────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close,
                        size: 30, color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Título ────────────────────────────────
              Text(
                _isLoginTab ? 'INICIAR SESIÓN' : 'CREAR CUENTA',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 24),

              // ── Tabs ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _LoginTab(
                      label: 'INICIAR SESIÓN',
                      selected: _isLoginTab,
                      onTap: () => setState(() => _isLoginTab = true),
                    ),
                    const SizedBox(width: 24),
                    _LoginTab(
                      label: 'CREAR CUENTA',
                      selected: !_isLoginTab,
                      onTap: () => setState(() => _isLoginTab = false),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),
              const Divider(height: 1, color: Color(0xFFDDDDDD)),

              // ── Formulario ────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isLoginTab
                            ? 'Bienvenido a Euronic Ai'
                            : 'Crea tu cuenta en Euronic Ai',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Nombre (solo en registro)
                      if (!_isLoginTab) ...[
                        const Text('Tu Nombre completo',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87)),
                        const SizedBox(height: 8),
                        _PillField(controller: _fullNameController),
                        const SizedBox(height: 20),
                      ],

                      // Email
                      const Text('Tu Correo electronico',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      _PillField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Contraseña
                      const Text('Tu Contraseña',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      _PillField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        suffix: GestureDetector(
                          onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),

                      // Olvidé contraseña (solo login)
                      if (_isLoginTab) ...[
                        const SizedBox(height: 12),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '¿Has olvidado tu contraseña?',
                            style: TextStyle(
                              color: _kAmber,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Botón principal
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kBtnDark,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isLoginTab
                                          ? 'Ingresar'
                                          : 'Crear cuenta',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 20),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Botones sociales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            child: const Text('f',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87)),
                          ),
                          const SizedBox(width: 18),
                          _SocialButton(
                            child: const Icon(Icons.apple,
                                size: 24, color: Colors.black87),
                          ),
                          const SizedBox(width: 18),
                          _SocialButton(
                            child: const Text('G+',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginTab extends StatelessWidget {
  const _LoginTab(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected ? Colors.black : Colors.black38,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selected ? 80 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1090),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFEAEAEA),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide:
              const BorderSide(color: Color(0xFF1A1090), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA – Modo Traductor
// ─────────────────────────────────────────────
class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage>
    with SingleTickerProviderStateMixin {
  String _sourceLang = 'Ingles';
  String _targetLang = 'Español';
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveCtrl.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final tmp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = tmp;
    });
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _waveCtrl.repeat(reverse: true);
      _timer =
          Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
    } else {
      _waveCtrl.stop();
      _waveCtrl.value = 0;
      _timer?.cancel();
      setState(() => _seconds = 0);
    }
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Área principal con gradiente ───────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                  colors: [
                    Color(0xFFCBCAF8),
                    Color(0xFFDDDCFF),
                    Color(0xFFF0F0FF),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          // Botón volver
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back,
                                size: 26, color: Colors.black87),
                          ),
                          const Spacer(),
                          // Selector de idiomas
                          _LangPill(label: _sourceLang),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _swapLanguages,
                            child: const Icon(Icons.swap_horiz_rounded,
                                size: 28, color: Colors.black87),
                          ),
                          const SizedBox(width: 10),
                          _LangPill(label: _targetLang),
                          const Spacer(),
                          // Configuración
                          GestureDetector(
                            onTap: () => _showTranslatorSettings(context),
                            child: const Icon(Icons.settings_outlined,
                                size: 26, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    // Área de traducción (vacía por ahora)
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),

          // ── Panel inferior blanco ──────────────────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ícono altavoz
                      const Icon(Icons.volume_up_rounded,
                          size: 36, color: Colors.black87),

                      // Botón micrófono central
                      GestureDetector(
                        onTap: _toggleRecording,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? const Color(0xFFE8E0FF)
                                : const Color(0xFFEEEEEE),
                            boxShadow: _isRecording
                                ? [
                                    BoxShadow(
                                      color: _kPurple.withAlpha(80),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            _isRecording ? Icons.mic : Icons.mic_none_rounded,
                            size: 38,
                            color: _isRecording ? _kPurple : Colors.black87,
                          ),
                        ),
                      ),

                      // Ícono forma de onda
                      _WaveformWidget(
                          controller: _waveCtrl,
                          active: _isRecording),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Timer
                  Text(
                    _timerText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  const _LangPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }
}

class _WaveformWidget extends StatelessWidget {
  const _WaveformWidget(
      {required this.controller, required this.active});
  final AnimationController controller;
  final bool active;

  static const _heights = [10.0, 22.0, 32.0, 18.0, 28.0, 14.0, 24.0];

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _heights
            .map((h) => Container(
                  width: 3.5,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ))
            .toList(),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_heights.length, (i) {
            final phase = (i / _heights.length);
            final scale =
                0.5 + 0.5 * ((t + phase) % 1.0 < 0.5 ? (t + phase) % 1.0 * 2 : 2 - (t + phase) % 1.0 * 2);
            return Container(
              width: 3.5,
              height: _heights[i] * scale,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: _kPurple,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA – Traducción sin conexión
// ─────────────────────────────────────────────
class OfflineTranslatorPage extends StatefulWidget {
  const OfflineTranslatorPage({super.key});

  @override
  State<OfflineTranslatorPage> createState() => _OfflineTranslatorPageState();
}

class _OfflineTranslatorPageState extends State<OfflineTranslatorPage>
    with SingleTickerProviderStateMixin {
  String _sourceLang = 'Ingles';
  String _targetLang = 'Español';
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _waveCtrl;
  final _sourceCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveCtrl.dispose();
    _sourceCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final tmpLang = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = tmpLang;
      final tmpText = _sourceCtrl.text;
      _sourceCtrl.text = _targetCtrl.text;
      _targetCtrl.text = tmpText;
    });
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _waveCtrl.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
    } else {
      _waveCtrl.stop();
      _waveCtrl.value = 0;
      _timer?.cancel();
      setState(() => _seconds = 0);
    }
  }

  String get _timerText {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Área con gradiente ─────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                  colors: [
                    Color(0xFFCBCAF8),
                    Color(0xFFDDDCFF),
                    Color(0xFFF0F0FF),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top bar: solo volver + configuración
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back,
                                size: 26, color: Colors.black87),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _showAudioSettings(context),
                            child: const Icon(Icons.settings_outlined,
                                size: 26, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tarjetas de traducción
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              // Tarjeta origen
                              _TranslationCard(
                                lang: _sourceLang,
                                controller: _sourceCtrl,
                                readOnly: false,
                              ),
                              const SizedBox(height: 8),
                              // Tarjeta destino
                              _TranslationCard(
                                lang: _targetLang,
                                controller: _targetCtrl,
                                readOnly: true,
                              ),
                            ],
                          ),
                          // Botón swap centrado entre tarjetas
                          GestureDetector(
                            onTap: _swapLanguages,
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.compare_arrows_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),

          // ── Panel inferior blanco ──────────────────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up_rounded,
                          size: 36, color: Colors.black87),
                      GestureDetector(
                        onTap: _toggleRecording,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? const Color(0xFFE8E0FF)
                                : const Color(0xFFEEEEEE),
                            boxShadow: _isRecording
                                ? [
                                    BoxShadow(
                                      color: _kPurple.withAlpha(80),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            _isRecording
                                ? Icons.mic
                                : Icons.mic_none_rounded,
                            size: 38,
                            color: _isRecording
                                ? _kPurple
                                : Colors.black87,
                          ),
                        ),
                      ),
                      _WaveformWidget(
                          controller: _waveCtrl,
                          active: _isRecording),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _timerText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslationCard extends StatelessWidget {
  const _TranslationCard({
    required this.lang,
    required this.controller,
    required this.readOnly,
  });
  final String lang;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label de idioma
          Row(
            children: [
              Text(
                lang,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.unfold_more,
                  size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 8),
          // Campo de texto
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                hintText: 'Introducir Texto',
                hintStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.black38,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// QR Scanner
// ─────────────────────────────────────────────
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    _handled = true;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(controller: _controller, onDetect: _onDetect),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA 3 – Home Dashboard
// ─────────────────────────────────────────────
class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key, required this.userName});
  final String userName;

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int _currentIndex = 0;

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Próximamente: $label'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPageBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero + tarjeta superpuesta ────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                _HeroBanner(onComprar: () => _showComingSoon('Comprar')),
                Positioned(
                  bottom: -32,
                  left: 16,
                  right: 16,
                  child: _UserGreetingCard(userName: widget.userName),
                ),
              ],
            ),

            // Espacio para la tarjeta superpuesta
            const SizedBox(height: 48),

            const SizedBox(height: 20),

            // Sección IA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          '¿En que Te puedo ayudar?',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const AIChatPage()),
                        ),
                        child: _RobotIcon(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _AIInputField(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const AIChatPage()),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sección traducción
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Text(
                'Traducción',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),

            _FeatureCard(
              icon: Icons.translate_rounded,
              label: 'Modo Traductor',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const TranslatorPage()),
              ),
            ),
            _FeatureCard(
              icon: Icons.wifi_off_rounded,
              label: 'Traducción sin conexión',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const OfflineTranslatorPage()),
              ),
            ),
            _FeatureCard(
              icon: Icons.record_voice_over_rounded,
              label: 'Traductor en Vivo',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const LiveTranslationPage()),
              ),
            ),
            _FeatureCard(
              icon: Icons.video_camera_front_rounded,
              label: 'Traducción de Video llamada',
              onTap: () => _showComingSoon('Traducción de Video llamada'),
            ),
            _FeatureCard(
              icon: Icons.mic_rounded,
              label: 'Traductor de Audios',
              onTap: () => _showComingSoon('Traductor de Audios'),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // ── Bottom Nav ───────────────────────────────
      bottomNavigationBar: _DashBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AIChatPage()),
            );
            return;
          }
          if (i == 2) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FindEarbudsPage()),
            );
            return;
          }
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}

// ─── Hero banner ──────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onComprar});
  final VoidCallback onComprar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF2A2A2A),
              child: const Icon(Icons.image_not_supported,
                  color: Colors.white38, size: 48),
            ),
          ),
          // Gradiente oscuro en la parte inferior
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(120),
                  ],
                ),
              ),
            ),
          ),
          // Botón COMPRAR
          Positioned(
            right: 16,
            top: 48,
            child: GestureDetector(
              onTap: onComprar,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'COMPRAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right,
                        color: Colors.white, size: 18),
                    Icon(Icons.chevron_right,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
          // Indicadores de página
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PageDot(active: true),
                const SizedBox(width: 6),
                _PageDot(active: false),
                const SizedBox(width: 6),
                _PageDot(active: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? _kAmber : Colors.white54,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ─── Tarjeta de saludo ────────────────────────────────
class _UserGreetingCard extends StatelessWidget {
  const _UserGreetingCard({required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE891C8), Color(0xFF9B5DE5)],
              ),
            ),
            child: const Center(
              child: Text('😊',
                  style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hola, $userName 👋',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Campana
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A1A1A),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_rounded,
                    color: _kAmber, size: 22),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ícono robot ──────────────────────────────────────
class _RobotIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00C6D4), Color(0xFF0077B6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C6D4).withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.smart_toy_rounded,
          color: Colors.white, size: 32),
    );
  }
}

// ─── Campo de entrada IA ──────────────────────────────
class _AIInputField extends StatelessWidget {
  const _AIInputField({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _kAmber, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Inicia una conversación con la ia',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _kAmber,
              ),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta de función ───────────────────────────────
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(18),
        elevation: 2,
        shadowColor: Colors.black.withAlpha(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _kAmber.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: _kAmber, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFFCCCCCC), size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom navigation ────────────────────────────────
class _DashBottomNav extends StatelessWidget {
  const _DashBottomNav(
      {required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  icon: Icons.home_rounded,
                  index: 0,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.smart_toy_rounded,
                  index: 1,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.manage_search_rounded,
                  index: 2,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.storefront_rounded,
                  index: 3,
                  current: currentIndex,
                  onTap: onTap),
              _NavItem(
                  icon: Icons.format_list_bulleted_rounded,
                  index: 4,
                  current: currentIndex,
                  onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.index,
    required this.current,
    required this.onTap,
  });
  final IconData icon;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? _kBtnDark : const Color(0xFFAAAAAA),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kAmber,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA – Chat IA
// ─────────────────────────────────────────────

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final List<_ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isKeyboardMode = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userMsg = text.trim();
    _textController.clear();

    setState(() {
      _messages.add(_ChatMessage(text: userMsg, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final history = _messages
          .where((m) => !_isLoading || m != _messages.last)
          .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
          .toList();

      final uri = Uri.parse('${ApiConfig.baseUrl}/ai/chat');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMsg, 'history': history}),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        setState(() {
          _messages.add(_ChatMessage(text: body['reply'] as String, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(_ChatMessage(
              text: body['message'] as String? ?? 'Error desconocido',
              isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(const _ChatMessage(
            text: 'No se pudo conectar con el servidor', isUser: false));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, size: 26, color: Colors.black87),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Inglés',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            // ── Mensajes ─────────────────────────────
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyAIState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (_isLoading && i == _messages.length) {
                          return const _TypingIndicator();
                        }
                        final msg = _messages[i];
                        return _MessageBubble(message: msg);
                      },
                    ),
            ),

            // ── Input ─────────────────────────────────
            Container(
              color: const Color(0xFFF5F5F7),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: _isKeyboardMode
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            autofocus: true,
                            textInputAction: TextInputAction.send,
                            onSubmitted: _sendMessage,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu pregunta...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _sendMessage(_textController.text),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF00C6D4), Color(0xFF0077B6)],
                              ),
                            ),
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _isKeyboardMode = false),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            child: const Icon(Icons.mic_rounded, color: Colors.black54, size: 22),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isKeyboardMode = true),
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mic_rounded, size: 20, color: Colors.black54),
                                  SizedBox(width: 8),
                                  Text(
                                    'Haz clic para hablar',
                                    style: TextStyle(fontSize: 15, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => _isKeyboardMode = true),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            child: const Icon(Icons.keyboard_rounded, color: Colors.black54, size: 22),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAIState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Robot ilustración
        SizedBox(
          width: 120,
          height: 130,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cuerpo del robot (chat bubble)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00C6D4), Color(0xFF0077B6)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _RobotEye(),
                          SizedBox(width: 14),
                          _RobotEye(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Antena
              Positioned(
                top: 0,
                child: Container(
                  width: 6,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A6B),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1A3A6B),
                  ),
                ),
              ),
              // Triángulo inferior del chat bubble
              Positioned(
                bottom: 0,
                left: 28,
                child: CustomPaint(
                  size: const Size(18, 12),
                  painter: _BubbleTailPainter(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Tarjeta de bienvenida
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Column(
            children: [
              Text(
                'Hola~ Soy tu asistente de IA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Si tienes dudas, pregúntame cuando quieras~',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RobotEye extends StatelessWidget {
  const _RobotEye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0077B6)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF00C6D4), Color(0xFF0077B6)],
                ),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF0077B6) : const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  color: message.isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00C6D4), Color(0xFF0077B6)],
              ),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const SizedBox(
              width: 36,
              height: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Dot(delay: 0),
                  _Dot(delay: 150),
                  _Dot(delay: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Configuración de Traducción (Bottom Sheet)
// ─────────────────────────────────────────────

enum _TranslatorMode { silencio, auriculares, altavoz, auricularesDuales }

void _showTranslatorSettings(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _TranslatorSettingsSheet(),
  );
}

class _TranslatorSettingsSheet extends StatefulWidget {
  const _TranslatorSettingsSheet();

  @override
  State<_TranslatorSettingsSheet> createState() => _TranslatorSettingsSheetState();
}

class _TranslatorSettingsSheetState extends State<_TranslatorSettingsSheet> {
  _TranslatorMode _selected = _TranslatorMode.auricularesDuales;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título + cerrar
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Configuración de traducción',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 24, color: Colors.black54),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SettingsOption(
            mode: _TranslatorMode.silencio,
            selected: _selected,
            title: 'Modo silencio',
            description: 'Solo muestra el resultado de la traducción sin sonido.',
            illustration: const _IllustrationSilencio(),
            onTap: (m) => setState(() => _selected = m),
          ),
          const SizedBox(height: 12),
          _SettingsOption(
            mode: _TranslatorMode.auriculares,
            selected: _selected,
            title: 'Modo auriculares',
            description: 'Hable con su teléfono y escuche la traducción en sus auriculares',
            illustration: const _IllustrationAuriculares(),
            onTap: (m) => setState(() => _selected = m),
          ),
          const SizedBox(height: 12),
          _SettingsOption(
            mode: _TranslatorMode.altavoz,
            selected: _selected,
            title: 'Modo altavoz',
            description: 'Toque para comenzar a hablar, y cuando deje de hablar, el sonido traducido se reproducirá desde el teléfono',
            illustration: const _IllustrationAltavoz(),
            onTap: (m) => setState(() => _selected = m),
          ),
          const SizedBox(height: 12),
          _SettingsOption(
            mode: _TranslatorMode.auricularesDuales,
            selected: _selected,
            title: 'Modo auriculares dobles',
            description: 'Una persona usa un auricular, habla al teléfono y escucha la traducción a través del auricular',
            illustration: const _IllustrationDuales(),
            onTap: (m) => setState(() => _selected = m),
          ),
        ],
      ),
    );
  }
}

class _SettingsOption extends StatelessWidget {
  const _SettingsOption({
    required this.mode,
    required this.selected,
    required this.title,
    required this.description,
    required this.illustration,
    required this.onTap,
  });

  final _TranslatorMode mode;
  final _TranslatorMode selected;
  final String title;
  final String description;
  final Widget illustration;
  final ValueChanged<_TranslatorMode> onTap;

  bool get _isSelected => mode == selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(mode),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: _isSelected
              ? Border.all(color: const Color(0xFFE8603A), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_isSelected)
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8603A),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else
              const SizedBox(width: 36),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            illustration,
          ],
        ),
      ),
    );
  }
}

// ── Ilustraciones ──────────────────────────────────────

class _TextLines extends StatelessWidget {
  const _TextLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 36, height: 5, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(3))),
        const SizedBox(height: 4),
        Container(width: 28, height: 5, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(3))),
        const SizedBox(height: 4),
        Container(width: 20, height: 5, decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(3))),
        const SizedBox(height: 6),
        Container(
          width: 20, height: 20,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE8A090)),
          child: const Icon(Icons.mic, size: 12, color: Colors.white),
        ),
      ],
    );
  }
}

class _IllustrationSilencio extends StatelessWidget {
  const _IllustrationSilencio();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _TextLines(),
        SizedBox(width: 6),
        Icon(Icons.volume_off_rounded, size: 28, color: Color(0xFF1A1A2E)),
      ],
    );
  }
}

class _IllustrationAuriculares extends StatelessWidget {
  const _IllustrationAuriculares();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _TextLines(),
        SizedBox(width: 6),
        Icon(Icons.headphones_rounded, size: 28, color: Color(0xFF1A1A2E)),
      ],
    );
  }
}

class _IllustrationAltavoz extends StatelessWidget {
  const _IllustrationAltavoz();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _TextLines(),
        SizedBox(width: 6),
        Icon(Icons.volume_up_rounded, size: 28, color: Color(0xFF1A1A2E)),
      ],
    );
  }
}

class _IllustrationDuales extends StatelessWidget {
  const _IllustrationDuales();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.headset_mic_rounded, size: 22, color: Color(0xFFE8603A)),
        SizedBox(width: 4),
        _TextLines(),
        SizedBox(width: 4),
        Icon(Icons.headset_mic_rounded, size: 22, color: Color(0xFFE8603A)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Configuración de Audio (Offline Translator)
// ─────────────────────────────────────────────

void _showAudioSettings(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AudioSettingsSheet(),
  );
}

class _AudioSettingsSheet extends StatefulWidget {
  const _AudioSettingsSheet();

  @override
  State<_AudioSettingsSheet> createState() => _AudioSettingsSheetState();
}

class _AudioSettingsSheetState extends State<_AudioSettingsSheet> {
  bool _reduccionRuido = true;
  bool _cancelacionEco = true;
  bool _controlGanancia = true;
  bool _deteccionIdioma = true;
  final String _entradaBluetooth = 'Entrada Bluetooth';
  final String _velocidad = '1.0x';
  final String _tamanoFuente = 'Normal';
  final String _idiomas = 'TODOS';

  static const _purple = Color(0xFF6A3DE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Título
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Configuración de audio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Contenido scrollable
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── ENTRADA DE AUDIO ──────────────────
                  _SectionHeader(label: 'CONFIGURACIÓN DE ENTRADA DE AUDIO'),
                  _SettingRow(
                    title: 'Fuente de entrada de interpretación simultánea',
                    value: _entradaBluetooth,
                    titleBold: true,
                    onTap: () {},
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // ── CALIDAD DE AUDIO ──────────────────
                  _SectionHeader(label: 'CONFIGURACIÓN DE CALIDAD DE AUDIO'),
                  const SizedBox(height: 8),
                  _ToggleRow(
                    title: 'Reducción de Ruido',
                    subtitle: 'Al activarse, se reducirá el ruido ambiental para mejorar la claridad de voz',
                    value: _reduccionRuido,
                    color: _purple,
                    onChanged: (v) => setState(() => _reduccionRuido = v),
                  ),
                  const SizedBox(height: 16),
                  _ToggleRow(
                    title: 'Cancelación de eco',
                    value: _cancelacionEco,
                    color: _purple,
                    onChanged: (v) => setState(() => _cancelacionEco = v),
                  ),
                  const SizedBox(height: 16),
                  _ToggleRow(
                    title: 'Control automático de ganancia',
                    value: _controlGanancia,
                    color: _purple,
                    onChanged: (v) => setState(() => _controlGanancia = v),
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // ── RECONOCIMIENTO DE VOZ ─────────────
                  _SectionHeader(label: 'CONFIGURACIÓN DE RECONOCIMIENTO DE VOZ'),
                  const SizedBox(height: 8),
                  _SettingRow(title: 'Imagen en imagen', onTap: () {}),
                  const SizedBox(height: 16),
                  _SettingRow(
                    title: 'Velocidad de reproducción',
                    value: _velocidad,
                    onTap: () {},
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // ── FUENTE ────────────────────────────
                  _SectionHeader(label: 'CONFIGURACIÓN DE FUENTE'),
                  const SizedBox(height: 8),
                  _SettingRow(
                    title: 'Tamaño de fuente',
                    value: _tamanoFuente,
                    onTap: () {},
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // ── IDIOMA ────────────────────────────
                  _SectionHeader(label: 'CONFIGURACIÓN DE IDIOMA'),
                  const SizedBox(height: 8),
                  _ToggleRow(
                    title: 'Detección de idioma',
                    value: _deteccionIdioma,
                    color: _purple,
                    onChanged: (v) => setState(() => _deteccionIdioma = v),
                  ),
                  const SizedBox(height: 16),
                  _SettingRow(
                    title: 'Descargar idiomas',
                    value: _idiomas,
                    valueUppercase: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black45,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    this.value,
    this.titleBold = false,
    this.valueUppercase = false,
    required this.onTap,
  });

  final String title;
  final String? value;
  final bool titleBold;
  final bool valueUppercase;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: titleBold ? FontWeight.w700 : FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          if (value != null)
            Text(
              valueUppercase ? value!.toUpperCase() : value!,
              style: TextStyle(
                fontSize: 14,
                color: valueUppercase ? const Color(0xFF6A3DE8) : Colors.black45,
                fontWeight: valueUppercase ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.black45, height: 1.4),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: color,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.black12,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA – Traducción en Vivo
// ─────────────────────────────────────────────

const _kLanguages = [
  'Español (Perú)',
  'Español (España)',
  'Español (México)',
  'Inglés',
  'Italiano',
  'Francés',
  'Portugués',
  'Alemán',
  'Chino',
  'Japonés',
  'Coreano',
  'Árabe',
  'Ruso',
];

class LiveTranslationPage extends StatefulWidget {
  const LiveTranslationPage({super.key});

  @override
  State<LiveTranslationPage> createState() => _LiveTranslationPageState();
}

class _LiveTranslationPageState extends State<LiveTranslationPage> {
  String _leftLang = 'Español (Perú)';
  String _rightLang = 'Italiano';

  Future<void> _pickLanguage({required bool isLeft}) async {
    final current = isLeft ? _leftLang : _rightLang;
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _LanguagePickerSheet(selected: current),
    );
    if (result != null && mounted) {
      setState(() {
        if (isLeft) {
          _leftLang = result;
        } else {
          _rightLang = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6, 1.0],
            colors: [Color(0xFFCBCAF8), Color(0xFFDFDEFF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back, size: 26, color: Colors.black87),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showTranslatorSettings(context),
                      child: const Icon(Icons.settings_outlined, size: 26, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              // ── Título ───────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 6),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.translate_rounded, color: Colors.white, size: 34),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Traducción\nen vivo',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Escucha y conversa con facilidad con personas que hablan otros idiomas.',
                  style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                ),
              ),

              // ── Auriculares + idiomas ─────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _EarbudColumn(
                        side: 'L',
                        language: _leftLang,
                        onPickLang: () => _pickLanguage(isLeft: true),
                      ),
                      _EarbudColumn(
                        side: 'R',
                        language: _rightLang,
                        onPickLang: () => _pickLanguage(isLeft: false),
                        mirrored: true,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Botón ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Iniciando traducción en vivo...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E0E0E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                    child: const Text(
                      'Iniciar Traducción',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarbudColumn extends StatelessWidget {
  const _EarbudColumn({
    required this.side,
    required this.language,
    required this.onPickLang,
    this.mirrored = false,
  });

  final String side;
  final String language;
  final VoidCallback onPickLang;
  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _EarbudWidget(side: side, mirrored: mirrored),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onPickLang,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                language,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.unfold_more_rounded, size: 18, color: Colors.black54),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarbudWidget extends StatelessWidget {
  const _EarbudWidget({required this.side, this.mirrored = false});

  final String side;
  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    final widget = SizedBox(
      width: 130,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Stem
          Positioned(
            bottom: 20,
            left: mirrored ? null : 38,
            right: mirrored ? 38 : null,
            child: Transform.rotate(
              angle: mirrored ? 0.3 : -0.3,
              child: Container(
                width: 38,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF8BAAF8),
                      const Color(0xFFB8C8FF).withAlpha(180),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          // Pod principal
          Positioned(
            top: 8,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.3, -0.3),
                  radius: 0.9,
                  colors: [
                    Color(0xFFB8CCFF),
                    Color(0xFF7A9BF5),
                    Color(0xFF5577E8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5577E8).withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          // Reflejo en el pod
          Positioned(
            top: 20,
            left: mirrored ? null : 28,
            right: mirrored ? 28 : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(60),
              ),
            ),
          ),
          // Badge L / R
          Positioned(
            bottom: 24,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2ECC71),
              ),
              child: Center(
                child: Text(
                  side,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return mirrored ? Transform.flip(flipX: true, child: widget) : widget;
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({required this.selected});
  final String selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'Seleccionar idioma',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _kLanguages.length,
            itemBuilder: (context, i) {
              final lang = _kLanguages[i];
              final isSelected = lang == selected;
              return ListTile(
                title: Text(
                  lang,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? const Color(0xFF5B3FD4) : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_rounded, color: Color(0xFF5B3FD4))
                    : null,
                onTap: () => Navigator.of(context).pop(lang),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA – Buscar Auriculares (Bluetooth)
// ─────────────────────────────────────────────

enum _SearchState { idle, searching, found }

class FindEarbudsPage extends StatefulWidget {
  const FindEarbudsPage({super.key});

  @override
  State<FindEarbudsPage> createState() => _FindEarbudsPageState();
}

class _FindEarbudsPageState extends State<FindEarbudsPage>
    with SingleTickerProviderStateMixin {
  _SearchState _state = _SearchState.idle;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _startSearch() async {
    setState(() => _state = _SearchState.searching);
    _pulseCtrl.repeat(reverse: true);

    // Simula búsqueda Bluetooth durante 3 segundos
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    _pulseCtrl.stop();
    _pulseCtrl.value = 0;
    setState(() => _state = _SearchState.found);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, size: 26, color: Colors.black87),
                  ),
                  const Expanded(
                    child: Text(
                      'Buscar Auriculares',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 26),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Tarjeta principal ────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Círculo amarillo + auriculares ─
                      ScaleTransition(
                        scale: _pulseAnim,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _state == _SearchState.found
                                  ? const Color(0xFF2ECC71)
                                  : _kAmber,
                              width: 18,
                            ),
                            color: const Color(0xFFF6F6F6),
                          ),
                          child: Center(
                            child: _state == _SearchState.found
                                ? _FoundBadge()
                                : _EarbudsIllustration(
                                    spinning: _state == _SearchState.searching,
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Nombre del dispositivo ─────────
                      Text(
                        _state == _SearchState.found
                            ? '.Euronic-Ai  ✓'
                            : '.Euronic-Ai',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _state == _SearchState.found
                              ? const Color(0xFF2ECC71)
                              : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Botón buscar ───────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _state == _SearchState.searching
                              ? null
                              : _state == _SearchState.found
                                  ? () => setState(() => _state = _SearchState.idle)
                                  : _startSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _state == _SearchState.found
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFF0E0E0E),
                            disabledBackgroundColor: Colors.black38,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                          ),
                          child: _state == _SearchState.searching
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5, color: Colors.white),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Buscando...',
                                        style: TextStyle(
                                            fontSize: 17, fontWeight: FontWeight.w700)),
                                  ],
                                )
                              : Text(
                                  _state == _SearchState.found
                                      ? 'Conectado'
                                      : 'Buscar Auricular',
                                  style: const TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w700),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Descripción ────────────────────
                      Text(
                        _state == _SearchState.found
                            ? 'Auriculares Euronic-Ai encontrados y conectados correctamente.'
                            : 'Los auriculares conectados van a emitir un sonido para poder encontrarlos con facilidad.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Bottom Nav ───────────────────────────
            _DashBottomNav(
              currentIndex: 2,
              onTap: (i) {
                if (i == 0) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                } else if (i == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const AIChatPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EarbudsIllustration extends StatefulWidget {
  const _EarbudsIllustration({required this.spinning});
  final bool spinning;

  @override
  State<_EarbudsIllustration> createState() => _EarbudsIllustrationState();
}

class _EarbudsIllustrationState extends State<_EarbudsIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(_EarbudsIllustration old) {
    super.didUpdateWidget(old);
    if (widget.spinning && !old.spinning) {
      _ctrl.repeat();
    } else if (!widget.spinning && old.spinning) {
      _ctrl.stop();
      _ctrl.value = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: widget.spinning ? _ctrl : const AlwaysStoppedAnimation(0),
      child: CustomPaint(
        size: const Size(140, 140),
        painter: _EarbudsPainter(),
      ),
    );
  }
}

class _EarbudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Earbud izquierdo ──────────────────────
    _drawEarbud(canvas, Offset(w * 0.32, h * 0.44), mirrored: false);
    // ── Earbud derecho ───────────────────────
    _drawEarbud(canvas, Offset(w * 0.68, h * 0.44), mirrored: true);
  }

  void _drawEarbud(Canvas canvas, Offset center, {required bool mirrored}) {
    final shadow = Paint()
      ..color = Colors.black.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final white = Paint()..color = const Color(0xFFF8F8F8);
    final lightGray = Paint()..color = const Color(0xFFE8E8E8);
    final darkGray = Paint()..color = const Color(0xFF888888);

    final flip = mirrored ? -1.0 : 1.0;

    // Sombra del pod
    canvas.drawOval(
      Rect.fromCenter(
          center: center.translate(2, 4), width: 44, height: 52),
      shadow,
    );

    // Pod principal (blanco)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 44, height: 52),
      white,
    );

    // Detalle interior oscuro
    canvas.drawOval(
      Rect.fromCenter(
          center: center.translate(0, -4), width: 22, height: 26),
      lightGray,
    );

    // Malla del altavoz
    canvas.drawOval(
      Rect.fromCenter(
          center: center.translate(0, -4), width: 14, height: 16),
      darkGray,
    );

    // Stem
    final stemTop = center.translate(flip * 2, 22);
    final stemRect = Rect.fromCenter(
        center: stemTop.translate(0, 22), width: 14, height: 36);
    final stemRRect =
        RRect.fromRectAndRadius(stemRect, const Radius.circular(7));
    canvas.drawRRect(stemRRect, white);

    // Muesca en el stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: stemTop.translate(0, 32), width: 8, height: 8),
        const Radius.circular(4),
      ),
      lightGray,
    );
  }

  @override
  bool shouldRepaint(_EarbudsPainter old) => false;
}

class _FoundBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2ECC71),
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 52),
    );
  }
}
