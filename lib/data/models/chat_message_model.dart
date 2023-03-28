import 'package:chatgptwizzard/domain/entities/chat_body.dart';

class ChatMessageModel extends ChatBody {
  ChatMessageModel({
    required super.msg,
    required super.chatIndex,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        msg: json['choices']['message']['content'],
        chatIndex: json['chatIndex'],
      );
  
}
