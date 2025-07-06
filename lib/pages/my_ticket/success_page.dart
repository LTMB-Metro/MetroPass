import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuccessPage extends StatefulWidget {
  final String? isScan;
  final String? userId;
  final String? userTicketId;

  const SuccessPage({
    super.key,
    this.isScan,
    this.userId,
    this.userTicketId,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playSound();
    });

    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _playSound() async {
    final assetPath = widget.isScan == 'true'
        ? 'audio/success.mp3'
        : 'audio/failure.mp3';

    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('🎧 Lỗi khi phát âm thanh: $e');
    }
  }

  Future<void> _resetIsScanToNull() async {
    if ((widget.isScan == 'true' || widget.isScan == 'false') &&
        widget.userId != null &&
        widget.userTicketId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId!)
            .collection('user_tickets')
            .doc(widget.userTicketId!)
            .update({'is_scan': null});
        debugPrint('✅ Đặt lại is_scan = null thành công');
      } catch (e) {
        debugPrint('⚠️ Lỗi khi đặt lại is_scan = null: $e');
      }
    }
  }


  @override
  void dispose() {
    _resetIsScanToNull(); // cập nhật về null khi thoát
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isScan == 'true' ? Colors.green : Colors.red,
      body: Center(
        child: Text(
          widget.isScan == 'true' ? 'Quét mã thành công' : 'Quét mã thất bại',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
