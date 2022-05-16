import 'package:flutter/material.dart';
import 'package:my_money/domain/user.dart';
import 'package:my_money/pages/notes/note_page.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:my_money/services/database.dart';
import 'package:my_money/title_info/note_title_info.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<NoteTitleInfo> notes = <NoteTitleInfo>[];

  MainUser? user;
  DatabaseService db = DatabaseService();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var stream = db.getNotes(author: user?.id);
    stream?.listen((List<NoteTitleInfo> data) {
      if (mounted)
        setState(() {
          notes.clear();
          notes.addAll(data);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MainUser?>(context);
    loadData();
    String temp_title = "";
    String temp_description = "";

    const Color _mainColor = Color.fromRGBO(61, 61, 61, 1);
    const Color _mainColorWhite = Colors.white;
    return Scaffold(
        body: NotesList(notes: notes),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NotePage(
                      onChangeTitle: (String value) {
                        if (mounted)
                          setState(() {
                            temp_title = value;
                          });
                      },
                      onChangeDescription: (String value) {
                        if (mounted)
                          setState(() {
                            temp_description = value;
                          });
                      },
                      onAddEdit: () async {
                        Navigator.pop(context);
                        await db.addOrUpdateNote(NoteTitleInfo(
                            title: temp_title,
                            description: temp_description,
                            author: user?.id));
                      },
                    )));
          },
          icon: Icon(Icons.add, color: Colors.deepOrange),
          label: Icon(Icons.note_add_outlined, color: Colors.deepOrange),
        ));
  }
}

class NotesList extends StatefulWidget {
  List<NoteTitleInfo> notes = <NoteTitleInfo>[];
  NotesList({Key? key, required this.notes}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState(this.notes);
}

class _NotesListState extends State<NotesList> {
  List<NoteTitleInfo> notes = <NoteTitleInfo>[];

  _NotesListState(this.notes);
  MainUser? user;
  //AuthService as = AuthService();
  DatabaseService db = DatabaseService();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var stream = db.getNotes(
      author: user?.id,
    );
    stream?.listen((List<NoteTitleInfo> data) {
      if (mounted)
        setState(() {
          notes.clear();
          notes.addAll(data);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    String tmp_title ;
    String tmp_description = "";
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          tmp_title = notes[index].title;
          tmp_description = notes[index].description;
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotePage(
                          title: notes[index].title,
                          description: notes[index].description,
                          onChangeTitle: (String value) {
                            if (mounted)
                              setState(() {
                                tmp_title = value;
                              });
                          },
                          onChangeDescription: (String value) {
                            if (mounted)
                              setState(() {
                                tmp_description = value;
                              });
                          },
                          onAddEdit: () async {
                            NoteTitleInfo tmp_note = NoteTitleInfo(
                                author: notes[index].author,
                                title: tmp_title,
                                description: tmp_description,
                                uid: notes[index].uid);
                            print(tmp_note.toMap());
                            Navigator.pop(context);
                            await db.addOrUpdateNote(tmp_note);
                          },
                        )));
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(116, 255, 86, 34),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    notes[index].title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                    maxLines: 1,
                  ),
                  subtitle: Container(
                    child: Text(
                      notes[index].description,
                      style: TextStyle(color: Colors.white),
                      maxLines: 3,
                    ),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        print("was del");
                        await db.deleteNote(this.notes[index]);
                      }),
                ),
              ));
        });
  }
}
