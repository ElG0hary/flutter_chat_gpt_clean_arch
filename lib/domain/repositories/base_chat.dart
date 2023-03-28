import 'package:chatgptwizzard/core/errors/failure.dart';
import 'package:chatgptwizzard/domain/entities/chat_body.dart';
import 'package:dartz/dartz.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, List<ChatBody>>> sendMessage(
      String message, String modelId);
}
