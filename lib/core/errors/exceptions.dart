class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Auth error']);
}

class StorageException implements Exception {
  final String message;
  const StorageException([this.message = 'Storage error']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}
