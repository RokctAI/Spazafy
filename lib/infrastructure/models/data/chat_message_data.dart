import 'package:venderfoodyman/infrastructure/services/customer/enums.dart';

class ChatMessageData {
  final MessageOwner messageOwner;
  final String message;
  final String time;
  final DateTime date;
  final String messageId;

  ChatMessageData({
    required this.messageOwner,
    required this.message,
    required this.time,
    required this.date,
    required this.messageId,
  });
}
