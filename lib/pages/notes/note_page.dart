import 'package:flutter/material.dart';
import 'package:my_money/title_info/note_title_info.dart';

class NotePage extends StatelessWidget {
  String title;
  String description;
  NoteTitleInfo? info;
  VoidCallback onAddEdit;
  Function(String) onChangeTitle;
  Function(String) onChangeDescription;

  NotePage({
    Key? key,
    required this.onAddEdit,
    required this.onChangeTitle,
    required this.onChangeDescription,
    this.title = "",
    this.description = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var txt2 = TextEditingController();
    txt2.text = description;
    var txt = TextEditingController();
    txt.text = title;
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
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
            onPressed: onAddEdit,
            icon: Icon(
              Icons.check,
              color: Colors.deepOrange,
            ),
          ),
        ]),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(children: [
          Container(
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Container(
              height: 500,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: txt,
                minLines: 1,
                maxLines: 3,
                maxLength: 100,
                onChanged: onChangeTitle,
                style: TextStyle(color: Colors.deepOrange),
                cursorColor: Colors.deepOrange,
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
          SizedBox(
            height: 30,
          ),
          Container(
            height: 500,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white)),
            child: TextField(
              controller: txt2,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 60,
              maxLines: 70,
              onChanged: onChangeDescription,
              style: TextStyle(color: Colors.deepOrange),
              cursorColor: Colors.deepOrange,
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
          )
        ]),
      ),
    );
  }
}
