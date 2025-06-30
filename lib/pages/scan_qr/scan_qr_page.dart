import 'package:flutter/material.dart';
import 'package:metropass/pages/scan_qr/scan_qr_in_out.dart';
import 'package:metropass/themes/colors/colors.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Quét mã QR')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quét mã QR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(MyColor.pr8)
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(MyColor.pr8)
              ),
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ScanQrInOut(typeScan: 'scanin')
                  )
                );
              }, 
              child: Text(
                'Quét mã tại ga vào',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.white)
                ),
              )
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(MyColor.pr8)
              ),
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ScanQrInOut(typeScan: 'scanout')
                  )
                );
              }, 
              child: Text(
                'Quét mã tại ga ra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(MyColor.white)
                ),
              )
            )
          ],
        ),
      )
    );
  }
}