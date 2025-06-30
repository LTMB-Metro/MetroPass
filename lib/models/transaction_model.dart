import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String transactionId;
  final String userId;
  final String type; 
  final String description;
  final int amount; 
  final String transactionCode;
  final DateTime createdAt;
  final String status; 
  final String? relatedTicketId; 
  final Map<String, dynamic>? metadata;

  TransactionModel({
    required this.transactionId,
    required this.userId,
    required this.type,
    required this.description,
    required this.amount,
    required this.transactionCode,
    required this.createdAt,
    required this.status,
    this.relatedTicketId,
    this.metadata,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      transactionId: id,
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      amount: map['amount'] ?? 0,
      transactionCode: map['transaction_code'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      relatedTicketId: map['related_ticket_id'],
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'type': type,
      'description': description,
      'amount': amount,
      'transaction_code': transactionCode,
      'created_at': createdAt,
      'status': status,
      if (relatedTicketId != null) 'related_ticket_id': relatedTicketId,
      if (metadata != null) 'metadata': metadata,
    };
  }

  // Getter để kiểm tra loại giao dịch
  bool get isIncome => amount > 0;
  bool get isExpense => amount < 0;

  // Getter để format loại giao dịch
  String get formattedType {
    switch (type) {
      case 'ticket_purchase':
        return 'Mua vé';
      case 'wallet_topup':
        return 'Nạp tiền';
      case 'refund':
        return 'Hoàn tiền';
      default:
        return 'Khác';
    }
  }

  // Getter để format trạng thái
  String get formattedStatus {
    switch (status) {
      case 'success':
        return 'Thành công';
      case 'pending':
        return 'Đang xử lý';
      case 'failed':
        return 'Thất bại';
      default:
        return 'Không xác định';
    }
  }
}
