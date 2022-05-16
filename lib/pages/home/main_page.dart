import 'package:flutter/material.dart';
import 'package:my_money/domain/user.dart';
import 'package:my_money/main.dart';
import 'package:my_money/pages/auth/login_page.dart';
import 'package:my_money/pages/home/home_page.dart';
import 'package:provider/provider.dart';
class MainPage extends StatelessWidget {
  const MainPage({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final MainUser? mainUser = Provider.of<MainUser?>(context);
    bool isLoggedIn = mainUser != null;
    return isLoggedIn ? HomePage() : LoginPage();
  }
}