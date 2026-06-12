import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'services/auth_service.dart';

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
                          const Icon(Icons.settings_outlined,
                              size: 26, color: Colors.black87),
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
                          const Icon(Icons.settings_outlined,
                              size: 26, color: Colors.black87),
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
      body: Column(
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

          // ── Contenido scrollable ─────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            _RobotIcon(),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _AIInputField(
                            onTap: () =>
                                _showComingSoon('Conversación IA')),
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
                    onTap: () => _showComingSoon('Traductor en Vivo'),
                  ),
                  _FeatureCard(
                    icon: Icons.video_camera_front_rounded,
                    label: 'Traducción de Video llamada',
                    onTap: () =>
                        _showComingSoon('Traducción de Video llamada'),
                  ),
                  _FeatureCard(
                    icon: Icons.mic_rounded,
                    label: 'Traductor de Audios',
                    onTap: () =>
                        _showComingSoon('Traductor de Audios'),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Nav ───────────────────────────────
      bottomNavigationBar: _DashBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
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
