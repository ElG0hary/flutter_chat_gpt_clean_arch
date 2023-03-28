import 'package:chatgptwizzard/data/datasources/chat_message_remote_data_source.dart';
import 'package:chatgptwizzard/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessageModel> chatList = [];
  List<ChatMessageModel> get getCurrentChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatMessageModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendUserMessageReceiveAnswer({
    required String msg,
    required String chosenModel,
  }) async {
    chatList.addAll(await ChatMessageRemoteDataSourceImpl().sendMessage(
        message: msg, modelId: chosenModel));
    notifyListeners();
  }
}
