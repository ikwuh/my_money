import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({Key? key}) : super(key: key);

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  List<String> categories = ['Простые проценты', 'Сложные проценты'];
  String? category;
  String? percents;
  String? startSum;
  String? daysCount;
  String? result = '';
  double res = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
                isExpanded: true,
                value: category == null ? category = 'Простые проценты': category,
                items: this.categories.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted)
                    setState(() {
                      category = value;
                    });
                }),
            TextField(
              
              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
              keyboardType: TextInputType.number,
              onChanged: (val) {
                startSum = val;
              },
              style: TextStyle(color: Colors.deepOrange),
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                hintText: 'начальная сумма',
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
            TextField(
              
              inputFormatters: [ FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
              keyboardType: TextInputType.number,
              onChanged: (val) {
                percents = val;
              },
              style: TextStyle(color: Colors.deepOrange),
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                hintText: 'ставка',
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
            TextField(
              
              inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              onChanged: (val) {
                daysCount = val;
              },
              style: TextStyle(color: Colors.deepOrange),
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                hintText: 'время в днях',
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
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.deepOrange,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              child: Text("Рассчитать"),
              onPressed: () {
                
                  if (daysCount! != '' && percents! != '' && startSum! != '') {
                    if (category == 'Простые проценты') {
                      res = (double.parse(startSum!) *
                              double.parse(percents!) *
                              (double.parse(daysCount!) / 365)) /
                          100;
                          setState(() {
                      result = (double.parse(startSum!) + res).toStringAsFixed(1);
                      });
                    } else {
                      double mult =((double.parse(percents!)/100) / 365);
                      res = double.parse(startSum!) * pow(1 + mult, double.parse(daysCount!)).toDouble();  
                      setState(() { 
                      result = res.toStringAsFixed(1);
                      });
                    }
                  }
                
              },
            ),
             SizedBox(
              height: 30,
            ),
            Text("Конечная сумма: " + result!),
          ],
        ));
  }
}
