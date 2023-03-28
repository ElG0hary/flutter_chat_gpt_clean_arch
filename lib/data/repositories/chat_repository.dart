import 'package:chatgptwizzard/core/errors/exceptions.dart';
import 'package:chatgptwizzard/data/datasources/chat_message_remote_data_source.dart';
import 'package:chatgptwizzard/data/models/chat_message_model.dart';
import 'package:chatgptwizzard/domain/entities/chat_body.dart';
import 'package:chatgptwizzard/core/errors/failure.dart';
import 'package:chatgptwizzard/domain/repositories/base_chat.dart';
import 'package:dartz/dartz.dart';

class ChatRepository extends BaseChatRepository {
  final ChatMessageRemoteDataSourceImpl _baseChatMessageRemoteDataSource;

  ChatRepository(this._baseChatMessageRemoteDataSource);

  @override
  Future<Either<Failure, List<ChatBody>>> sendMessage(
      String message, String modelId) async {
    final result = await _baseChatMessageRemoteDataSource.sendMessage(
        message: message, modelId: modelId);
    return _dataOrException(result);
  }

  Either<Failure, List<ChatBody>> _dataOrException(
      List<ChatMessageModel> result) {
    try {
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.serverErrorMessage.message));
    }
  }
}
