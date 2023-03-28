import 'dart:convert';
import 'dart:io';

import 'package:chatgptwizzard/core/network/api_constants.dart';
import 'package:chatgptwizzard/data/models/chat_message_model.dart';
import 'package:http/http.dart' as http;

abstract class BaseChatMessageRemoteDataSource {
  Future<List<ChatMessageModel>> sendMessage({
    required String message,
    required String modelId,
  });
}

class ChatMessageRemoteDataSourceImpl extends BaseChatMessageRemoteDataSource {
  @override
  Future<List<ChatMessageModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiStrings.BASE_URL}/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${ApiStrings.chatGptApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.7
          },
        ),
      );
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }
      List<ChatMessageModel> chatList = [];
      if (jsonResponse['choices'].length > 0) {
        //* chatgpt response is here
        chatList = List.generate(
          jsonResponse['choices'].length,
          (index) => ChatMessageModel(
            msg: jsonResponse['choices'][index]['message']['content'],
            //! cuz 1 is the index for bot and user is 0
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (e) {
      rethrow;
    }
  }
}
