import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // Web (Chrome) y desktop usan localhost directamente
    if (kIsWeb) return 'http://localhost:4000';

    // Android emulator accede al host por 10.0.2.2
    // iOS simulator y macOS/Windows desktop usan localhost
    return 'http://10.0.2.2:4000';
  }
}
