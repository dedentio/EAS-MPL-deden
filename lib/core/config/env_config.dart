class EnvConfig {
  EnvConfig._();

  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'DEV - Deden');
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://newsapi.org/v2/');

  static bool get isProduction => environment == 'PROD';
}