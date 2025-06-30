import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SuccessPage extends StatefulWidget {
  final String? isScan;
  const SuccessPage({super.key, this.isScan});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    // Đảm bảo widget đã được render trước khi phát âm thanh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playSound();
    });

    // Tự động quay lại màn trước sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
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

  @override
  void dispose() {
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
