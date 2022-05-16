import 'package:flutter/material.dart';
import 'package:my_money/domain/user.dart';
import 'package:my_money/services/auth.dart';
import 'package:my_money/services/database.dart';
import 'package:provider/provider.dart';

import '../../title_info/account_title_info.dart';
import '../operations/operations_page.dart';

class AccountPage extends StatefulWidget {
  final AccountTitleInfo account;
  final String? accountId;
  const AccountPage({Key? key, required this.accountId, required this.account})
      : super(key: key);

  @override
  State<AccountPage> createState() =>
      _AccountPageState(this.accountId, this.account);
}

class _AccountPageState extends State<AccountPage> {
  String? accountId;
  MainUser? user;
  AuthService as = AuthService();
  DatabaseService db = DatabaseService();
  AccountTitleInfo account;
  List<AccountTitleInfo> acc= [];
  _AccountPageState(this.accountId, this.account);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var stream = db.getAccount(author: user?.id, accountId: accountId);
    stream?.listen((List<AccountTitleInfo> data) {
      if (mounted)
        setState(() {
          acc.clear();
          acc.addAll(data);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MainUser?>(context);
    loadData();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.deepOrange,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 80),
          child: Column(children: [
            Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ Text(account.balance,
                      style:
                          TextStyle(fontSize: 22, color: Color.fromARGB(175, 255, 86, 34), fontWeight: FontWeight.w600)),
                          
              Icon(
                Icons.monetization_on_outlined,
                color: Color.fromARGB(175, 255, 86, 34),
                size: 30,
        )]),SizedBox(
                  height: 45,
                ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.add_shopping_cart,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.car_repair_outlined,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.local_cafe_outlined,
                    percent: 80,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.bus_alert,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.wallet_travel_outlined,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.health_and_safety,
                    percent: 80,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.headset_mic_outlined,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.house_outlined,
                    percent: 80,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 1,
                  child: CategoryCard(
                    name: account.balance,
                    icon: Icons.cake_rounded,
                    percent: 80,
                  ),
                ),
              ],
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OperationsPage(
                      accountId: accountId,
                    )));
          },
          label: Icon(
            Icons.monetization_on_outlined,
            color: Colors.deepOrange,
          ),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final double percent;
  final IconData icon;
  const CategoryCard(
      {Key? key, required this.name, required this.icon, required this.percent})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(116, 255, 86, 34)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          percent.toString() + "%",
          style: TextStyle(
            color: Colors.white,
          ),
        )
      ]),
    );
  }
}
