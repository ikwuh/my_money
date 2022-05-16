import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_money/domain/user.dart';
import 'package:my_money/pages/auth/login_page.dart';
import 'package:my_money/pages/auth/register_page.dart';
import 'package:my_money/pages/home/home_page.dart';
import 'package:my_money/pages/home/main_page.dart';
import 'package:my_money/services/auth.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({Key? key}) : super(key: key);

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  String email = "";

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    _getHeader() {
      return Expanded(
        flex: 2,
        child: Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Смена пароля',
            style: TextStyle(color: Colors.white, fontSize: 37),
          ),
        ),
      );
    }

    _getInputs() {
      return Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'email'),
            ),
            
          ],
        ),
      );
    }

    _getSignIn() {
      return Expanded(
        flex: 1,
        child: (Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Сменить пароль',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            IconButton(
              onPressed: () async {
                email = emailController.text.trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Неверный email",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      webBgColor: "linear-gradient(to right, #DAA393, #DAA393)",
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
                else {
                   
                 AuthService().changePassword(email);
                  emailController.clear();
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            )
          ],
        )),
      );
    }

    _getBottomRow() {
      return Expanded(
          flex: 1,
          child:Row(children: [
        Expanded(
          flex: 1,
          child: Center(
              child: (GestureDetector(
            child: Text(
              'Назад',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ))),
        ),
        
      ]));
    }

    return Scaffold(
      body: CustomPaint(
        painter: BackgroundSignIn(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getInputs(),
                  _getSignIn(),
                  _getBottomRow(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    // Blue
    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.42);
    blueWave.quadraticBezierTo(sw * 0.2, sh * 0.55, sw * 0.4, 0);
    blueWave.close();
    paint.color = Color.fromARGB(185, 202, 147, 130);
    canvas.drawPath(blueWave, paint);

    // Grey
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.85, sh * 0.15, sw * 0.75, sh * 0.15, sw * 0.6, sh * 0.3);
    greyWave.cubicTo(sw * 0.52, sh * 0.55, sw * 0.30, sh * 0.33, 0, sh * 0.4);
    greyWave.close();
    paint.color = Color.fromARGB(255, 218, 163, 147);
    canvas.drawPath(greyWave, paint);

    // Yellow
    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.3, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Color.fromARGB(185, 202, 147, 130);
    canvas.drawPath(yellowWave, paint);

    Path whiteWave = Path();

    whiteWave.lineTo(sw * 0.0, sh * 0.35);
    whiteWave.cubicTo(
        sw * 0.53, sh * 0.4, sw * 0.7, sh * 0.01, sw * 0.35, sh * 0.12);
    whiteWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    whiteWave.close();
    paint.color = Color.fromARGB(90, 194, 126, 106);
    canvas.drawPath(whiteWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
