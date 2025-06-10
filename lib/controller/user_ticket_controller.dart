import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/models/user_ticket_model.dart';

class UserTicketController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserTicketModel>> getUserTicketsStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _db
        .collection('user_tickets')
        .where('user_id', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> createUserTicket(TicketTypeModel ticketType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User chưa đăng nhập");
    final now = DateTime.now();
    final docRef = FirebaseFirestore.instance.collection('user_tickets').doc();
    final userTicketId = docRef.id;
    final qrContent = userTicketId;
    final userTicket = UserTicketModel(
      userTicketId: userTicketId,
      userId: user.uid,
      ticketName: ticketType.type == 'single' ? 'Vé Lượt' : ticketType.ticketName,
      ticketType: ticketType.type,
      note: ticketType.note,
      description: ticketType.description,
      price: ticketType.price,
      duration: ticketType.duration,
      startStationCode: ticketType.fromCode == '' ? 'all' : ticketType.fromCode,
      endStationCode: ticketType.toCode == '' ? 'all' :ticketType.toCode,
      status: 'unused',
      bookingTime: now,
      qrCodeContent: qrContent,
    );
    await docRef.set(userTicket.toMap());
  }

  Stream<List<UserTicketModel>> getTicketsByStatus(String status) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _db
        .collection('user_tickets')
        .where('user_id', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
