import 'package:chatgptwizzard/core/constants/colors.dart';
import 'package:chatgptwizzard/presentation/components/chat_widget.dart';
import 'package:chatgptwizzard/presentation/components/text_message_widget.dart';
import 'package:chatgptwizzard/presentation/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController _textEditingController;
  late ScrollController _chatListScrollController;
  late FocusNode _keyboardFocus;

  //Speech Variables
  late String currentLocaleId;
  bool isListening = false;
  // late List<LocaleName> availableLocales;

  //switch for speech
  late SharedPreferences sharedPreferences;
  late bool isSpeaking = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _chatListScrollController = ScrollController();
    _keyboardFocus = FocusNode();
    // getCurrentLocale();
    initSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _chatListScrollController.dispose();
    _keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 2,
      //   actions: [
      //     Switch(
      //       value: isSpeaking,
      //       onChanged: (newValue) async {
      //         await sharedPreferences.setBool('gptIsSpeaking', newValue);
      //         FlutterTts().stop();
      //         setState(() {
      //           isSpeaking = newValue;
      //         });
      //       },
      //     ),
          // IconButton(
          //     onPressed: () async =>
          //         await Services.showModalBotSheet(context: context),
          //     icon: const Icon(
          //       Icons.more_vert_rounded,
          //       color: Colors.white,
          //     )),
      //   ],
      //   leading: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Image.asset(AssetsManager.openaiLogo),
      //   ),
      //   title: const Text('ChatGPT'),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _chatListScrollController,
                itemCount: chatProvider.getCurrentChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    chatIndex: chatProvider.getCurrentChatList[index].chatIndex,
                    msg: chatProvider.getCurrentChatList[index].msg,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(height: 15),
            Container(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _keyboardFocus,
                        onSubmitted: (message) async => await sendMessage(
                          modelId: 'gpt-3.5-turbo',
                          chatProvider: chatProvider,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton(
                              //   onPressed: toggleRecording,
                              //   icon: Icon(
                              //     isListening ? Icons.mic : Icons.mic_none,
                              //     size: 36,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              IconButton(
                                onPressed: () async => await sendMessage(
                                  modelId: 'gpt-3.5-turbo',
                                  chatProvider: chatProvider,
                                ),
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          hintText: 'How can i help you?',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        controller: _textEditingController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollToChatListEnd() {
    _chatListScrollController.animateTo(
      _chatListScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage({
    required String modelId,
    required ChatProvider chatProvider,
  }) async {
    if (_textEditingController.text.isEmpty) {
      showSnackBarMessage('Can\'t send an Empty Message!');
      return;
    }
    if (_isTyping) {
      showSnackBarMessage('Only 1 message at time');
      return;
    }
    try {
      setState(() {
        _isTyping = true;
        //saving user Message
        chatProvider.addUserMessage(msg: _textEditingController.text);
        _keyboardFocus.unfocus();
      });
      //! add alone won't work need to have add all since it's a list
      await chatProvider.sendUserMessageReceiveAnswer(
        msg: _textEditingController.text,
        chosenModel: modelId,
      );
      //! needs to be here or would get a weird response
      _textEditingController.clear();
    } catch (error) {
      showSnackBarMessage(error.toString());
    } finally {
      setState(() {
        scrollToChatListEnd();
        _isTyping = false;
      });
    }
  }

  void showSnackBarMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextMessageWidget(
          label: error,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
/*
  Future toggleRecording() => SpeechToTextRecognition.toggleRecording(
        onResult: (text) => setState(() => _textEditingController.text = text),
        onListening: (isListening) {
          setState(
            () => this.isListening = isListening,
          );
        },
        languageId: currentLocaleId,
      );

  Future getCurrentLocale() => SpeechToTextRecognition.initSpeech(
        currentLocaleId: (currentLocaleId) {
          setState(
            () => this.currentLocaleId = currentLocaleId,
          );
        },
        availableLocales: (availableLocales) {
          this.availableLocales = availableLocales;
        },
      );
      */

  Future<void> initSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.containsKey('gptIsSpeaking')
        ? isSpeaking = sharedPreferences.getBool('gptIsSpeaking')!
        : isSpeaking = false;

    sharedPreferences.containsKey('currentLocaleId')
        ? setState(() {
            currentLocaleId = sharedPreferences.getString('currentLocaleId')!;
          })
        : '';
  }
}
