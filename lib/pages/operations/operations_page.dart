import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_money/pages/notes/note_page.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:my_money/services/database.dart';
import 'package:my_money/title_info/note_title_info.dart';
import 'package:my_money/title_info/operations_title_info.dart';
import 'package:provider/provider.dart';

import '../../domain/user.dart';

typedef StringCallback = void Function(String? value);
typedef DateCallback = void Function(DateTime? value);

class OperationAddDialog extends StatefulWidget {
  final bool operationType;
  final VoidCallback onAdd;

  final DateCallback onChangeDate;

  final Function(String) onChangeTitle;
  final Function(String) onChangeBalance;
  const OperationAddDialog(
      {Key? key,
      required this.onAdd,
      required this.operationType,
      required this.onChangeTitle,
      required this.onChangeBalance,
      required this.onChangeDate})
      : super(key: key);

  @override
  State<OperationAddDialog> createState() => _OperationAddDialogState(
      this.onAdd,
      this.operationType,
      this.onChangeTitle,
      this.onChangeBalance,
      this.onChangeDate);
}

class _OperationAddDialogState extends State<OperationAddDialog> {
  DateTime selectedDate = DateTime.now();
  bool operationType;
  final VoidCallback onAdd;

  final DateCallback onChangeDate;
  final Function(String) onChangeTitle;
  final Function(String) onChangeBalance;
  _OperationAddDialogState(
    this.onAdd,
    this.operationType,
    this.onChangeTitle,
    this.onChangeBalance,
    this.onChangeDate,
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      if (mounted)
        setState(() {
          selectedDate = picked;
        });
    }
    onChangeDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 300,
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
                    maxLength: 25,
                    style: TextStyle(color: Colors.deepOrange),
                    cursorColor: Colors.deepOrange,
                    onChanged: onChangeTitle,
                    decoration: InputDecoration(
                      hintText: 'Название',
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
                      hintText: operationType ? 'Получено': 'Потрачено',
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
                  margin: EdgeInsets.only(top: 8, right: 5, left: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.deepOrange,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onPressed: () => _selectDate(context),
                    child: Text(selectedDate.day.toString() +
                        "." +
                        selectedDate.month.toString() +
                        "." +
                        selectedDate.year.toString()),
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




class OperationsPage extends StatefulWidget {
  final String? accountId;
  const OperationsPage({Key? key, required this.accountId}) : super(key: key);

  @override
  State<OperationsPage> createState() => _OperationsPageState(this.accountId);
}

class _OperationsPageState extends State<OperationsPage> {
  MainUser? user;
  String? accountId;
  DatabaseService db = DatabaseService();
  List<OperationsTitleInfo> operations = [];
  _OperationsPageState(this.accountId);
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var stream = db.getOperations(author: user?.id, accountId: accountId);
    stream?.listen((List<OperationsTitleInfo> data) {
      if (mounted)
        setState(() {
          operations.clear();
          operations.addAll(data);
        });
    });
  }

  showDisDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String _title = "";
          String _count = "";
          DateTime? _date = DateTime.now();
          return OperationAddDialog(
            operationType: false,
            onAdd: () async {
              await db.addOrUpdateOperation(OperationsTitleInfo(
                  title: _title,
                  count: _count,
                  operationType: false,
                  date: _date,
                  author: user?.id,
                  accountId: this.accountId));
             await loadData();
            },
            
            onChangeTitle: (title) {
              if (mounted)
                setState(() {
                  _title = title;
                });
            },
            onChangeBalance: (count) {
              if (mounted)
                setState(() {
                  _count = count;
                });
            },
            onChangeDate: (date) {
              if (mounted)
                setState(() {
                  _date = date;
                });
            },
          );
        });
  }

  showAddDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          String _title = "";
          String _count = "";
          DateTime? _date = DateTime.now();
          return OperationAddDialog(
            operationType: true,
            onAdd: () async {
              await db.addOrUpdateOperation(OperationsTitleInfo(
                  title: _title,
                  count: _count,
                  operationType: true,
                  date: _date,
                  author: user?.id,
                  accountId: this.accountId));
                 await loadData();
            },
            
            onChangeTitle: (title) {
              if (mounted)
                setState(() {
                  _title = title;
                });
            },
            onChangeBalance: (count) {
              if (mounted)
                setState(() {
                  _count = count;
                });
            },
            onChangeDate: (date) {
              if (mounted)
                setState(() {
                  _date = date;
                });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MainUser?>(context);
    loadData();
    const Color _mainColor = Color.fromRGBO(61, 61, 61, 1);
    const Color _mainColorWhite = Colors.white;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.deepOrange,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: OperationsList(
          operations: operations,
          accountId: accountId,
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ 
            
          FloatingActionButton.extended(
            heroTag: 'getOp',
            backgroundColor: Colors.white,
            onPressed: showAddDialog,
            label:
                Icon(Icons.attach_money_outlined, color: Colors.green),
          ),
          SizedBox(width: 7,),
          FloatingActionButton.extended(
            
            heroTag: 'giveOp',
            backgroundColor: Colors.white,
            onPressed: showDisDialog,
            label:
                Icon(Icons.money_off_csred_rounded, color: Colors.red),
          ),
        ]));
  }
}

class OperationsList extends StatefulWidget {
  String? accountId;
  List<OperationsTitleInfo> operations = <OperationsTitleInfo>[];
  OperationsList({Key? key, required this.operations, required this.accountId})
      : super(key: key);

  @override
  State<OperationsList> createState() =>
      _OperationsListState(this.operations, this.accountId);
}

class _OperationsListState extends State<OperationsList> {
  List<OperationsTitleInfo> operations = <OperationsTitleInfo>[];
  String? accountId;
  _OperationsListState(this.operations, this.accountId);
  MainUser? user;
  //AuthService as = AuthService();
  DatabaseService db = DatabaseService();

  loadData() async {
    var stream = db.getOperations(author: user?.id, accountId: accountId);
    stream?.listen((List<OperationsTitleInfo> data) {
      if (mounted)
        setState(() {
          operations.clear();
          operations.addAll(data);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    user = Provider.of<MainUser?>(context);
    return ListView.builder(
        itemCount: operations.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(113, 255, 86, 34),
            ),
            child: ListTile(
              leading: operations[index].operationType == true
                  ? Icon(
                      Icons.attach_money_rounded,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.money_off_csred_rounded,
                      color: Colors.red,
                    ),
              title: Text(
                operations[index].title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                maxLines: 1,
              ),
              subtitle: Container(
                child: Row(children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      operations[index].count,
                      style: TextStyle(color: Colors.white),
                      maxLines: 5,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${operations[index].date?.day}.${operations[index].date?.month}",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    db.deleteOperation(this.operations[index]);
                    operations.removeAt(index);
                  }),
            ),
          );
        });
  }
}
