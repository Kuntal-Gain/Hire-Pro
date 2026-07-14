import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseManager {
  const SupabaseManager._();

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  static RealtimeClient get realtime => client.realtime;

  static SupabaseQueryBuilder from(String table) {
    return client.from(table);
  }

  static PostgrestFilterBuilder<dynamic> rpc(String fn, {Map<String, dynamic>? params}) {
    return client.rpc(fn, params: params);
  }

  static String? get currentUserId => auth.currentUser?.id;

  static User? get currentUser => auth.currentUser;

  static bool get isAuthenticated => currentUser != null;
}
