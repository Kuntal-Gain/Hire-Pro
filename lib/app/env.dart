import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Env {
  const Env._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  static String get supabaseUrl => dotenv.env['SUPABASE_URL']!;

  static String get supabasePubKey => dotenv.env['SUPABASE_PUB_KEY']!;
}
