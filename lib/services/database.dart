import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_money/title_info/account_title_info.dart';
import 'package:my_money/title_info/operations_title_info.dart';

import '../title_info/note_title_info.dart';

class DatabaseService {
  double result = 0.0;
  final CollectionReference _AccountTitleInfoCollection =
      FirebaseFirestore.instance.collection('Accounts');
  final CollectionReference _OperationsTitleInfoCollection =
      FirebaseFirestore.instance.collection('Operations');

  final CollectionReference _NotesSchedulesTitleInfoCollection =
      FirebaseFirestore.instance.collection('NotesSchedules');
  final CollectionReference _NotesTitleInfoCollection =
      FirebaseFirestore.instance.collection('Notes');

  Future addOrUpdateAccount(AccountTitleInfo account) async {
    return await _AccountTitleInfoCollection.doc(account.uid)
        .set(account.toMap());
  }

  Future deleteAccount(AccountTitleInfo account) async {
    
    return await _AccountTitleInfoCollection.doc(account.uid).delete();
  }

  Stream<List<AccountTitleInfo>>? getAccounts({String? author}) {
    Query? query;
    if (author != null)
      query = _AccountTitleInfoCollection.where('author', isEqualTo: author);
    return query?.snapshots().map((QuerySnapshot data) => data.docs     
        .map((DocumentSnapshot doc) => AccountTitleInfo.fromJson(
            doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  Stream<List<AccountTitleInfo>>? getAccount({String? author, String? accountId}) {
    Query? query;
    if (author != null) {
      query = _AccountTitleInfoCollection.where('author', isEqualTo: author);
      query = query.where('accountId', isEqualTo: accountId);
    }

    return query?.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => AccountTitleInfo.fromJson(
            doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  Future addOrUpdateOperation(OperationsTitleInfo operation) async {
    double balance = 0.0;
    await _AccountTitleInfoCollection.doc(operation.accountId)
        .get().then((snapshot){
     
      balance = double.parse((snapshot.data() as Map<String, dynamic>)["balance"]);
      print(balance);
    });
    
    await _AccountTitleInfoCollection.doc(operation.accountId)
        .update({
    "balance": (balance + double.parse(operation.count)*(operation.operationType ? 1 : -1 )).toString(),
  });
    return await _OperationsTitleInfoCollection.doc(operation.uid)
        .set(operation.toMap());

  }

  Future deleteOperation(OperationsTitleInfo operation) async {
    //   print("operation.author " + operation.author!);

    //   print("operation.accountId " + operation.accountId!);
    //   Query? query;
    //   if(operation != null){
    //     query = _OperationsTitleInfoCollection.where('author', isEqualTo: operation.author);
    //     query = query.where('accountId', isEqualTo: operation.accountId);
    //   }

    //   return query?.snapshots().map((QuerySnapshot data) =>
    // data.docs.map((DocumentSnapshot doc) => print(
     double balance = 0.0;
    await _AccountTitleInfoCollection.doc(operation.accountId)
        .get().then((snapshot){
     
      balance = double.parse((snapshot.data() as Map<String, dynamic>)["balance"]);
      print(balance);
    });
    
    await _AccountTitleInfoCollection.doc(operation.accountId)
        .update({
    "balance": (balance + double.parse(operation.count)*(operation.operationType ? -1 : 1 )).toString(),
  }); 

    return await _OperationsTitleInfoCollection.doc(operation.uid)
        .delete(); //)));
  }

  Stream<List<OperationsTitleInfo>>? getOperations(
      {String? author, String? accountId}) {
    Query? query;
    if (author != null) {
      query = _OperationsTitleInfoCollection.where('author', isEqualTo: author);
      query = query.where('accountId', isEqualTo: accountId);
    }

    return query?.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) => OperationsTitleInfo.fromJson(
            doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future addOrUpdateNote(NoteTitleInfo note) async {
    DocumentReference notesRef = _NotesTitleInfoCollection.doc(note.uid);
    print(note.toMap());
    return notesRef.set(note.toNoteMap()).then((_) async {
      var docId = notesRef.id;
      await _NotesSchedulesTitleInfoCollection.doc(docId).set(note.toMap());
    });
  }

  Future deleteNote(NoteTitleInfo note) async {
    _NotesTitleInfoCollection.doc(note.uid).delete();
    return await _NotesSchedulesTitleInfoCollection.doc(note.uid).delete();
  }

  Stream<List<NoteTitleInfo>>? getNotes({String? author}) {
    Query? query;
    if (author != null)
      query = _NotesTitleInfoCollection.where('author', isEqualTo: author);

    return query?.snapshots().map((QuerySnapshot data) => data.docs
        .map((DocumentSnapshot doc) =>
            NoteTitleInfo.fromJson(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }
  
  
}
