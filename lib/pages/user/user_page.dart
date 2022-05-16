import 'package:flutter/material.dart';
import 'package:my_money/domain/user.dart';
import 'package:my_money/pages/auth/change_pass_page.dart';
import 'package:my_money/pages/home/main_page.dart';
import 'package:my_money/services/auth.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({ Key? key }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
  
    
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon( 
          Icons.account_circle_outlined,
          size: 60,
          color: Colors.deepOrange,
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.close_rounded, color: Colors.deepOrange,),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "Log out",
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
              IconButton(onPressed: ()async{await AuthService().LogOut();}, icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.deepOrange, size: 22,)),
              
            ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.password_rounded, color: Colors.deepOrange,),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "Change password",
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
              IconButton(onPressed: ()async{Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePassPage(
                    )));
              }, icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.deepOrange, size: 22,)),
              
            ],
        )
      ]),
    );
  }
}
