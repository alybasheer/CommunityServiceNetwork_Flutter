abstract class AppExceptions implements Exception {
  final String msg;
  final String? details;

  AppExceptions(this.msg, this.details);

  @override
  String toString() {
    final prefix = details?.trim() ?? '';
    if (prefix.isEmpty) return msg;
    return '$prefix $msg'.trim();
  }
}

class FetchDataExceptions extends AppExceptions {
  FetchDataExceptions([String? msg]) : super(msg ?? 'Something went wrong', '');
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? msg]) : super(msg ?? 'Invalid request', '');
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? msg]) : super(msg ?? 'Unauthorized', '');
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? msg]) : super(msg ?? 'Invalid input', '');
}
