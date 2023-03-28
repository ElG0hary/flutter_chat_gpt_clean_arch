import 'package:chatgptwizzard/data/models/error_message_model.dart';

class ServerException implements Exception {
  final ErrorMessageModel serverErrorMessage;

  ServerException({
    required this.serverErrorMessage,
  });
}
