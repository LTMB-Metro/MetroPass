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
        .collection('users')
        .doc(currentUser.uid)
        .collection('user_tickets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> createUserTicket(TicketTypeModel ticketType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User chưa đăng nhập");
    final now = DateTime.now();
    final docRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('user_tickets')
        .doc();
    final userTicketId = docRef.id;
    final qrContent = userTicketId;
    Timestamp? autoActivateTime;
    if (ticketType.type == 'single') {
      autoActivateTime = null;
    } else {
      if(ticketType.duration < 5) {
        autoActivateTime = Timestamp.fromDate(now.add(Duration(days: ticketType.duration * 30)));
      } else {
        autoActivateTime = Timestamp.fromDate(now.add(Duration(days: 180)));
      }
    }
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
      endStationCode: ticketType.toCode == '' ? 'all' : ticketType.toCode,
      status: 'unused',
      bookingTime: now,
      qrCodeContent: qrContent,
      autoActivateTime: autoActivateTime?.toDate()
    );
    await docRef.set(userTicket.toMap());
  }

  Stream<List<UserTicketModel>> getTicketsByStatus(String status) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(currentUser.uid)
        .collection('user_tickets')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }
  
  Future<UserTicketModel?> getUserTicketById(String userTicketId, String userId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('user_tickets')
        .doc(userTicketId)
        .get();

    if (doc.exists) {
      return UserTicketModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
  bool isValidStationForTicket(UserTicketModel ticket, String stationCode) {
    if(ticket.status == 'expired') return false;
    if(ticket.inactiveTime == null || ticket.inactiveTime!.isAfter(DateTime.now())) {
      if (ticket.startStationCode == 'all' || ticket.endStationCode == 'all') {
        return true;
      }
      if(ticket.numberUsed == null || ticket.numberUsed! < 1) {
        if (ticket.startStationCode == stationCode) {
          return true;
        }else{
          return false;
        }
      }
      if(ticket.numberUsed == null || ticket.numberUsed! == 1) {
        if(ticket.endStationCode == stationCode) {
          return true;
        }
      }
    }
    return false;
  }
  
  Future<bool> validateAndUseTicket({
    required String userTicketId,
    required String userId,
    required String stationCode,
  }) async {
    final ticket = await getUserTicketById(userTicketId, userId);
    if (ticket == null) return false;

    if (!isValidStationForTicket(ticket, stationCode)) return false;

    Timestamp? inactiveTime;
    if (ticket.ticketType == 'single') {
      inactiveTime = null;
    } else {
      inactiveTime = Timestamp.fromDate(DateTime.now().add(Duration(days: ticket.duration)));
    }
    final updateData = <String, dynamic>{
      'number_used': (ticket.numberUsed ?? 0) + 1,
    };
    if (ticket.numberUsed == null || ticket.numberUsed == 0) {
      updateData['inactive_time'] = inactiveTime;
      updateData['activate_time'] = DateTime.now();
      updateData['status'] = 'active';
    } else {
      if (stationCode == ticket.endStationCode) {
        final now = DateTime.now();
        updateData['inactive_time'] = Timestamp.fromDate(now);
        updateData['status'] = 'expired';
      }
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('user_tickets')
        .doc(userTicketId)
        .update(updateData);

    return true;
  }
  
  Future<void> checkAndUpdateAutoActivation(UserTicketModel ticket) async {
    final now = DateTime.now();
    if (ticket.autoActivateTime != null &&
        ticket.status == 'unused' &&
        ticket.autoActivateTime!.isBefore(now)) {
      final inactiveTime = ticket.duration > 0
          ? ticket.autoActivateTime!.add(Duration(days: ticket.duration))
          : null;

      await _db
          .collection('users')
          .doc(ticket.userId)
          .collection('user_tickets')
          .doc(ticket.userTicketId)
          .update({
            'status': 'active',
            'activate_time': ticket.autoActivateTime,
            'inactive_time': inactiveTime,
          });
    }
    if (ticket.inactiveTime != null &&
        ticket.status != 'expired' &&
        ticket.inactiveTime!.isBefore(now)) {
      await _db
          .collection('users')
          .doc(ticket.userId)
          .collection('user_tickets')
          .doc(ticket.userTicketId)
          .update({
            'status': 'expired',
          });
    }
  }

  Future<void> checkAndUpdateAllAutoActivation(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('user_tickets')
        .get();

    for (final doc in snapshot.docs) {
      final ticket = UserTicketModel.fromMap(doc.data(), doc.id);
      await checkAndUpdateAutoActivation(ticket);
    }
  }
  Stream<List<UserTicketModel>> getUserTickets(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('user_tickets')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserTicketModel.fromMap(doc.data(), doc.id))
            .toList());
  }


  Stream<List<TicketTypeModel>> getTicketTypesFromUserTickets() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Nếu chưa đăng nhập, trả về stream rỗng hoặc throw tùy bạn xử lý
      return const Stream.empty();
    }

    return getUserTickets(user.uid).map((userTickets) =>
      userTickets.map((userTicket) => TicketTypeModel(
        description: userTicket.description,
        duration: userTicket.duration,
        note: userTicket.note,
        ticketName: userTicket.ticketType == 'single'
            ? userTicket.description
            : userTicket.ticketName,
        type: userTicket.ticketType,
        categories: userTicket.ticketType == 'HSSV' ? 'student' : 'normal',
        price: userTicket.price,
        fromCode: userTicket.startStationCode,
        toCode: userTicket.endStationCode,
        qrCodeURL: '',
      )).toList()
    );
  }

}

