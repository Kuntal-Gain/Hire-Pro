/// Postgres/PostgREST error codes + HTTP-equivalent status codes.
/// Centralizing these avoids magic-string comparisons scattered
/// across every repository's catch block.
class StatusCodes {
  StatusCodes._();

  // Generic HTTP
  static const ok = 200;
  static const created = 201;
  static const noContent = 204;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const notFound = 404;
  static const conflict = 409;
  static const tooManyRequests = 429;
  static const serverError = 500;

  // Postgres error codes (from PostgrestException.code)
  static const pgForeignKeyViolation = '23503';
  static const pgUniqueViolation = '23505';
  static const pgCheckViolation = '23514';
  static const pgNotNullViolation = '23502';

  // PostgREST/Supabase specific
  static const pgrstJwtExpired = 'PGRST301';
  static const pgrstNoRows = 'PGRST116';
  static const pgrstBadRequest = 'PGRST100';

  // Supabase Auth error codes (from AuthException.code)
  static const authInvalidCredentials = 'invalid_credentials';
  static const authEmailNotConfirmed = 'email_not_confirmed';
  static const authUserAlreadyExists = 'user_already_exists';
  static const authWeakPassword = 'weak_password';
  static const authSessionExpired = 'session_expired';
}
