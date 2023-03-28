import 'package:equatable/equatable.dart';

class ErrorMessage extends Equatable {
  final String message;
  final String type;

  const ErrorMessage({
    required this.message,
    required this.type,
  });

  @override
  List<Object?> get props => [
        message,
        type,
      ];
}
