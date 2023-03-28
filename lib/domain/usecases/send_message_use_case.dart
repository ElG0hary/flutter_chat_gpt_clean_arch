import 'package:chatgptwizzard/core/errors/failure.dart';
import 'package:chatgptwizzard/domain/entities/chat_body.dart';
import 'package:chatgptwizzard/domain/repositories/base_chat.dart';
import 'package:chatgptwizzard/domain/usecases/base_message_use_case.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase
    extends BaseMessageUseCaseParameter<List<ChatBody>, String> {
  final BaseChatRepository _baseChatRepository;

  SendMessageUseCase(this._baseChatRepository);

  @override
  Future<Either<Failure, List<ChatBody>>> call(
          String message, String modelId) async =>
      await _baseChatRepository.sendMessage(
        message,
        modelId,
      );
}
