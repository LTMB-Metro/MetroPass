import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metropass/pages/welcome/welcome_page.dart';
import 'package:metropass/themes/colors/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      ),
      child: Scaffold(
        extendBody: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 376,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/metromap.png',
                        ),
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      )
                    ),
                  ),
                  const SizedBox(height: 200),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          buildhelp(
                            context, 
                            AssetImage('assets/images/help.png'), 
                            'MetroPass có nhiều loại vé khác nhau cho bạn lựa chọn', 
                            WelcomePage()
                          ),
                          buildhelp(
                            context, 
                            AssetImage('assets/images/help2.png'),
                            'MetroPass sẽ cung cấp cho bạn thông tin về các tuyến Metro', 
                            WelcomePage()
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
              Positioned(
                top: 312,
                left: 17,
                right: 17,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(MyColor.pr1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        Image.asset(
                          'assets/images/logo.png'
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/ticket1.png'), 'Đặt vé', WelcomePage()),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/ticket2.png'), 'Vé của tôi', WelcomePage()),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/ticket3.png'), 'Thông tin', WelcomePage()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/map1.png'), 'Lộ trình', WelcomePage()),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/map2.png'), 'Bản đồ', WelcomePage()),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildIcon(context, Image.asset('assets/images/profile.png'), 'Tài khoản', WelcomePage()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildIcon(BuildContext context, Image image , String lable, Widget targetpage){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => targetpage )
        );
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(MyColor.pr3),
              borderRadius: BorderRadius.circular(50)
            ),
            child: image,
          ),
          const SizedBox(height: 4,),
          Text(lable,
            style: TextStyle(
              fontSize: 14,
              color: Color(MyColor.black)
            ),
          )
        ],
      ),
    );
  }
  Widget buildhelp(BuildContext context, ImageProvider image, String lable, Widget targetpage){
    return GestureDetector(
      onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => targetpage),
      );
    },
      child: Container(
        width: 302,
        height: 220,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 0.1),
            )
          ],
          color: Color(MyColor.white)
        ),
        child: Column(
          children: [
            Container(
              height: 154,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image, fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lable,
                    style: TextStyle(
                      color: Color(MyColor.black),
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    'Nhấn để xem ngay',
                    style: TextStyle(
                      color: Color(MyColor.grey),
                      fontSize: 14,
                      fontWeight: FontWeight.w300
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
