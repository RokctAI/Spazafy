import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models.dart';

class WalletHistoryData {
  final String? id;
  final String? uuid;
  final String? walletUuid;
  final String? transactionId;
  final String? type;
  final double? price;
  final String? note;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final UserData? user;
  final UserData? author;
  final TransactionData? transaction;

  WalletHistoryData({
    this.id,
    this.uuid,
    this.walletUuid,
    this.transactionId,
    this.type,
    this.price,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.author,
    this.transaction,
  });

  factory WalletHistoryData.fromJson(Map<String, dynamic> json) {
    return WalletHistoryData(
      id: json['id']?.toString(),
      uuid: json['uuid']?.toString(),
      walletUuid: json['wallet_uuid']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      type: json['type'],
      price: json['price']?.toDouble(),
      note: json['note'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      author: json['author'] != null ? UserData.fromJson(json['author']) : null,
      transaction: json['transaction'] != null
          ? TransactionData.fromJson(json['transaction'])
          : null,
    );
  }
}
