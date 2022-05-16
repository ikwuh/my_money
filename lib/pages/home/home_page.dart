import 'package:flutter/material.dart';
import 'package:my_money/pages/accounts/accounts_page.dart';
import 'package:my_money/pages/notes/notes_page.dart';
import 'package:my_money/pages/calc/calc_page.dart';
import 'package:my_money/pages/user/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pages = [AccontsPage(), NotesPage(), CalcPage(), UserPage()];
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    const Color _mainColor = Color.fromRGBO(61, 61, 61, 1);
    const Color _mainColorWhite = Colors.white;
    return Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: Container(
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -1),
                  color: Colors.black12,
                  blurRadius: 35,
                )
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: onTap,
              currentIndex: currentIndex,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.deepOrange.withOpacity(0.5),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.note_alt_outlined), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calculate_outlined), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined), label: ""),
              ],
            ),
          ),
        ),
      
    );
  }
}
