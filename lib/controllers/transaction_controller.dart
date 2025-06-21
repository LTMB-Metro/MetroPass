import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class TransactionController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy stream lịch sử giao dịch của user hiện tại
  Stream<List<TransactionModel>> getUserTransactionsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _db
        .collection('transactions')
        .where('user_id', isEqualTo: currentUser.uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Lấy lịch sử giao dịch với phân trang
  Future<List<TransactionModel>> getUserTransactionsPaginated({
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    Query query = _db
        .collection('transactions')
        .where('user_id', isEqualTo: currentUser.uid)
        .orderBy('created_at', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => TransactionModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  // Lấy giao dịch theo loại
  Stream<List<TransactionModel>> getTransactionsByType(String type) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _db
        .collection('transactions')
        .where('user_id', isEqualTo: currentUser.uid)
        .where('type', isEqualTo: type)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Lấy giao dịch theo khoảng thời gian
  Stream<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _db
        .collection('transactions')
        .where('user_id', isEqualTo: currentUser.uid)
        .where('created_at', isGreaterThanOrEqualTo: startDate)
        .where('created_at', isLessThanOrEqualTo: endDate)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Tạo giao dịch mới
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      final docRef = _db.collection('transactions').doc();
      final transactionWithId = TransactionModel(
        transactionId: docRef.id,
        userId: transaction.userId,
        type: transaction.type,
        description: transaction.description,
        amount: transaction.amount,
        transactionCode: transaction.transactionCode,
        createdAt: transaction.createdAt,
        status: transaction.status,
        relatedTicketId: transaction.relatedTicketId,
        metadata: transaction.metadata,
      );

      await docRef.set(transactionWithId.toMap());
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Tạo giao dịch mua vé
  Future<void> createTicketPurchaseTransaction({
    required String ticketName,
    required int amount,
    required String ticketId,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User chưa đăng nhập");

    final transactionCode = _generateTransactionCode();
    final transaction = TransactionModel(
      transactionId: '',
      userId: currentUser.uid,
      type: 'ticket_purchase',
      description: 'Mua $ticketName',
      amount: -amount, // Số âm vì là chi tiêu
      transactionCode: transactionCode,
      createdAt: DateTime.now(),
      status: 'success',
      relatedTicketId: ticketId,
      metadata: {
        'ticket_name': ticketName,
        'payment_method': 'vnpay', // hoặc method khác
      },
    );

    await createTransaction(transaction);
  }

  // Tạo giao dịch nạp tiền
  Future<void> createTopupTransaction({
    required int amount,
    required String paymentMethod,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User chưa đăng nhập");

    final transactionCode = _generateTransactionCode();
    final transaction = TransactionModel(
      transactionId: '',
      userId: currentUser.uid,
      type: 'wallet_topup',
      description: 'Nạp tiền ví',
      amount: amount, // Số dương vì là thu nhập
      transactionCode: transactionCode,
      createdAt: DateTime.now(),
      status: 'success',
      metadata: {'payment_method': paymentMethod},
    );

    await createTransaction(transaction);
  }

  // Tạo giao dịch hoàn tiền
  Future<void> createRefundTransaction({
    required String ticketName,
    required int amount,
    required String ticketId,
    required String reason,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("User chưa đăng nhập");

    final transactionCode = _generateTransactionCode();
    final transaction = TransactionModel(
      transactionId: '',
      userId: currentUser.uid,
      type: 'refund',
      description: 'Hoàn tiền vé $ticketName',
      amount: amount, // Số dương vì là hoàn tiền
      transactionCode: transactionCode,
      createdAt: DateTime.now(),
      status: 'success',
      relatedTicketId: ticketId,
      metadata: {'ticket_name': ticketName, 'refund_reason': reason},
    );

    await createTransaction(transaction);
  }

  // Lấy thống kê giao dịch
  Future<Map<String, dynamic>> getTransactionStats() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return {};

    final snapshot =
        await _db
            .collection('transactions')
            .where('user_id', isEqualTo: currentUser.uid)
            .get();

    final transactions =
        snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
            .toList();

    int totalIncome = 0;
    int totalExpense = 0;
    int totalTransactions = transactions.length;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount.abs();
      }
    }

    return {
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'total_transactions': totalTransactions,
      'balance': totalIncome - totalExpense,
    };
  }

  // Generate mã giao dịch
  String _generateTransactionCode() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();
    return '#MT${timestamp.substring(timestamp.length - 6)}';
  }

  // Tìm kiếm giao dịch
  Future<List<TransactionModel>> searchTransactions(String query) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final snapshot =
        await _db
            .collection('transactions')
            .where('user_id', isEqualTo: currentUser.uid)
            .get();

    final transactions =
        snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
            .where(
              (transaction) =>
                  transaction.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  transaction.transactionCode.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }
}
