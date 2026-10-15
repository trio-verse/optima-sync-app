class ServerException implements Exception {
  final int? statusCode;
  const ServerException([this.statusCode]);
}

class BadRequestException implements Exception {
  final String? message;
  const BadRequestException([this.message]);
}

class NotFoundException implements Exception {
  const NotFoundException();
}

class NoContentException implements Exception {
  const NoContentException();
}

class OfflineException implements Exception {
  const OfflineException();
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class NoOrganizationException implements Exception {
  const NoOrganizationException();
}
