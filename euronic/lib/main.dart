import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const EuronicApp());
}

class EuronicApp extends StatelessWidget {
  const EuronicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euronic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _licenseCode = '';

  Future<void> _scanQrCode() async {
    final scannedCode = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const QrScannerPage(),
      ),
    );

    if (scannedCode == null || scannedCode.isEmpty) {
      return;
    }

    final normalizedCode = scannedCode
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toUpperCase();

    if (!mounted) {
      return;
    }

    setState(() {
      _licenseCode = normalizedCode.length > 5
          ? normalizedCode.substring(0, 5)
          : normalizedCode;
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
            colors: [
              Color(0xFF0A1030),
              Color(0xFF1706A8),
              Color(0xFFBFC2EE),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxHeight < 750;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Rompe\nfronteras\ncon cada\npalabra"',
                          style: TextStyle(
                            color: Colors.white,
                            height: 0.95,
                            fontWeight: FontWeight.w800,
                            fontSize: isSmall ? 52 : 62,
                          ),
                        ),
                        const SizedBox(height: 26),
                        const _DecorativeTopSection(),
                        const SizedBox(height: 26),
                        const Center(
                          child: Text(
                            'Escanea el Codigo QR para obtener tu licencia\nlibre, o create una cuenta.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _LicenseCodeInputs(code: _licenseCode),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Expanded(
                              child: _PrimaryActionButton(label: 'Activar Licencia'),
                            ),
                            const SizedBox(width: 14),
                            _IconSquareButton(
                              icon: Icons.qr_code_scanner_rounded,
                              onTap: _scanQrCode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _PrimaryActionButton(
                          label: 'Iniciar Sesion',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                        const Spacer(),
                        const SizedBox(height: 30),
                        const _SocialRow(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginTab = true;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFA7A8F1),
              Color(0xFFF3F3FB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(26, 18, 26, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 48, color: Color(0xFF1D1D24)),
                    ),
                  ),
                  const SizedBox(height: 58),
                  const Center(
                    child: Text(
                      'INICIAR SESION',
                      style: TextStyle(
                        color: Color(0xFF101015),
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 54),
                  Row(
                    children: [
                      _AuthTab(
                        label: 'INICIAR SESION',
                        selected: _isLoginTab,
                        onTap: () => setState(() => _isLoginTab = true),
                      ),
                      const SizedBox(width: 50),
                      _AuthTab(
                        label: 'CREAR CUENTA',
                        selected: !_isLoginTab,
                        onTap: () => setState(() => _isLoginTab = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 64),
                  const Center(
                    child: Text(
                      'Bienvenido a Euronic Ai',
                      style: TextStyle(
                        color: Color(0xFF141419),
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 58),
                  const _FieldLabel('Tu Correo electronico'),
                  const SizedBox(height: 14),
                  const _RoundedInputField(),
                  const SizedBox(height: 42),
                  const _FieldLabel('Tu Contraseña'),
                  const SizedBox(height: 14),
                  _RoundedInputField(
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF25252D),
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    '¿Has olvidado tu contraseña?',
                    style: TextStyle(
                      color: Color(0xFFD4AF35),
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 56),
                  SizedBox(
                    width: double.infinity,
                    height: 92,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF111317),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ingresar',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.login_rounded, size: 48),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  const _SocialRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF101015) : const Color(0xFF85858F),
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 4,
            width: 122,
            color: selected ? const Color(0xFF6D7BF9) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF11131A),
        fontSize: 38,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _RoundedInputField extends StatelessWidget {
  const _RoundedInputField({
    this.obscureText = false,
    this.suffix,
  });

  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E6F2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        obscureText: obscureText,
        style: const TextStyle(fontSize: 22, color: Color(0xFF13161E)),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

class _DecorativeTopSection extends StatelessWidget {
  const _DecorativeTopSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Column(
        children: [
          Container(
            height: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Row(
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 58,
                  width: 58,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6E57B4),
                  ),
                  child: const Icon(Icons.record_voice_over_rounded, color: Colors.white, size: 34),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF3C3A96),
                          child: Icon(Icons.translate_rounded, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF2D2E90),
                      child: Icon(Icons.mic_rounded, color: Colors.white, size: 32),
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

class _LicenseCodeInputs extends StatelessWidget {
  const _LicenseCodeInputs({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final character = index < code.length ? code[index] : '';
        return Container(
          height: 74,
          width: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white70, width: 2),
          ),
          child: Text(
            character,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }),
    );
  }
}

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
    if (_handled) {
      return;
    }
    if (capture.barcodes.isEmpty) {
      return;
    }
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) {
      return;
    }
    _handled = true;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Escanear QR'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          const Align(
            alignment: Alignment(0, 0.8),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Apunta la cámara al código QR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111317),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          textStyle: const TextStyle(fontSize: 46, fontWeight: FontWeight.w500),
        ),
        child: FittedBox(child: Text(label)),
      ),
    );
  }
}

class _IconSquareButton extends StatelessWidget {
  const _IconSquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      width: 140,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E2E39),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
        child: Icon(icon, size: 48),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _SocialBubble(label: 'f'),
        SizedBox(width: 20),
        _SocialBubble(label: 'Apple'),
        SizedBox(width: 20),
        _SocialBubble(label: 'G+'),
      ],
    );
  }
}

class _SocialBubble extends StatelessWidget {
  const _SocialBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      width: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.black54, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
