import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_money/services/auth.dart';
import 'package:my_money/services/database.dart';
import 'package:my_money/title_info/account_title_info.dart';
import 'package:my_money/pages/accounts/account_page.dart';
import 'package:provider/provider.dart';

import '../../domain/user.dart';
import '../operations/operations_page.dart';

class AccontsPage extends StatefulWidget {
  const AccontsPage({Key? key}) : super(key: key);

  @override
  _AccontsPageState createState() => _AccontsPageState();
}

class _AccontsPageState extends State<AccontsPage> {
  MainUser? user;
  AuthService as = AuthService();
  DatabaseService db = DatabaseService();

  List<AccountTitleInfo> accounts =[]; //[AccountTitleInfo(title: "asd", balance: "123"),AccountTitleInfo(title: "asd", balance: "123")];
 
  @override
  void initState() {
    loadData();
    super.initState();
    
  }

  loadData() async {
    var stream = db.getAccounts(author: user?.id);
    stream?.listen((List<AccountTitleInfo> data) {
      if(mounted)
      setState(() {
        accounts.clear();
        accounts.addAll(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MainUser?>(context);
    loadData();
    as.getCurrentUserInfo();
    //loadData();
    const Color _mainColor = Color.fromRGBO(61, 61, 61, 1);
    const Color _mainColorWhite = Colors.white;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Icon(Icons.account_circle_outlined, color: Colors.deepOrange, size: 25,),
              
        title: Text(as.userEmail, style: TextStyle(color: Colors.deepOrange, fontSize: 14)),
        
      ),
      body: AccountsList(
        accounts: accounts,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.add,
          color: Colors.deepOrange,
        ),
        label: Icon(
          Icons.account_balance_outlined,
          color: Colors.deepOrange,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String _title = "";
                String _balance = "";
                return AccountAddDialog(
                  onAdd: () async {
                    Navigator.of(context).pop();
                    await DatabaseService().addOrUpdateAccount(AccountTitleInfo(
                        title: _title, balance: _balance, author: user?.id, ));
                   await loadData();
                  },
                  onChangeTitle: (title) {
                    if(mounted)
                    setState(() {
                      _title = title;
                    });
                  },
                  onChangeBalance: (balance) {
                    if(mounted)
                    setState(() {
                      _balance = balance;
                    });
                  },
                );
              });
        },
      ),
    );
  }
}

class AccountAddDialog extends StatelessWidget {
  final VoidCallback onAdd;
  final Function(String) onChangeTitle;
  final Function(String) onChangeBalance;
  const AccountAddDialog(
      {Key? key,
      required this.onAdd,
      required this.onChangeTitle,
      required this.onChangeBalance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8, left: 50, right: 50),
                  child: TextField(
                    maxLength: 20,
                    style: TextStyle(color: Colors.deepOrange),
                    cursorColor: Colors.deepOrange,
                    onChanged: onChangeTitle,
                    decoration: InputDecoration(
                      hintText: '',
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(113, 255, 86, 34),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8, left: 50, right: 50),
                  child: TextField(
                    
              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
              keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.deepOrange),
                    cursorColor: Colors.deepOrange,
                    onChanged: onChangeBalance,
                    decoration: InputDecoration(
                      hintText: 'Баланс',
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(113, 255, 86, 34),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Color.fromARGB(113, 255, 86, 34),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "back",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8, right: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Color.fromARGB(113, 255, 86, 34),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onPressed: onAdd,
                      child: Text(
                        "add",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountsList extends StatefulWidget {
  List<AccountTitleInfo> accounts = <AccountTitleInfo>[];
  AccountsList({Key? key, required this.accounts}) : super(key: key);

  @override
  State<AccountsList> createState() => _AccountsListState(this.accounts);
}

class _AccountsListState extends State<AccountsList> {
  List<AccountTitleInfo> accounts = <AccountTitleInfo>[];
  
  _AccountsListState(this.accounts);
  MainUser? user;
  //AuthService as = AuthService();
  DatabaseService db = DatabaseService();
 @override
  void initState() {
    loadData();
    super.initState();
    
  }

  loadData() async {
    var stream = db.getAccounts(author: user?.id);
    stream?.listen((List<AccountTitleInfo> data) {
      if(mounted)
      setState(() {
        accounts.clear();
        accounts.addAll(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    user = Provider.of<MainUser?>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int i) {
            return AccontCard(
              accountInfo: accounts[i],
              onDismissed: () {
                // if(mounted)
                // setState(() {
                //   accounts.add(AccountTitleInfo(
                //       title: accounts[i].title, balance: accounts[i].balance));
                // });
                
                print(this.accounts[i].uid);
                db.deleteAccount(this.accounts[i]);
                loadData();
              },
            );
          }),
    );
  }
}

class AccontCard extends StatelessWidget {
  
  final AccountTitleInfo accountInfo;
  final VoidCallback onDismissed;
  AccontCard({
    Key? key,
    required this.accountInfo,
    required this.onDismissed,
  }) : super(key: key);
  
  showOperations(context) {
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OperationsPage(accountId: accountInfo.uid,)));
                }
  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 350,
        height: 180,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            color: Color.fromARGB(113, 255, 86, 34)),
        child: Stack(
          children: [
            Positioned(
                top: 40,
                left: 35,
                child: Text("ACCOUNT NAME",
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            Positioned(
              top: 55,
              left: 35,
              child: Text(accountInfo.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
            Positioned(
              top: 90,
              left: 35,
              child: Row(children: [
                Text("BALANCE", style: TextStyle(color: Colors.white)),
                Icon(
                  Icons.attach_money_rounded,
                  color: Colors.white,
                  size: 20,
                )
              ]),
            ),
            Positioned(
                top: 110,
                left: 35,
                child: Text(accountInfo.balance,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700))),
            Positioned(
                top: 22,
                right: 30,
                child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: onDismissed,
              
              ),
                ),
            Positioned(
              bottom: 35,
              right: 30,
              child: IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: showOperations(context),
              ),
            ),
          ],
        ),
      
    );
  }
}
