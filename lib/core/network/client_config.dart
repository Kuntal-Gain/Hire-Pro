import 'package:hire_pro/app/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



final class SupabaseConfig {
  const SupabaseConfig._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePubKey,
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      realtimeClientOptions: const RealtimeClientOptions(),
      storageOptions: const StorageClientOptions(),
      postgrestOptions: const PostgrestClientOptions(),
    );
  }
}
