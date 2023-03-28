import 'package:chatgptwizzard/domain/entities/error_message.dart';

class ErrorMessageModel extends ErrorMessage {
  const ErrorMessageModel({required super.message, required super.type});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) =>
      ErrorMessageModel(
        message: json['errors']['message'],
        type: json['errors']['type'],
      );
}
