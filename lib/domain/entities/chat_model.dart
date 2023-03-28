import 'package:equatable/equatable.dart';

class ChatAiModel extends Equatable {
  final String id, root;
  final int created;

  const ChatAiModel({
    required this.id,
    required this.root,
    required this.created,
  });

  @override
  List<Object?> get props => [
        id,
        root,
        created,
      ];
}
