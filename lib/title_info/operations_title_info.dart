class Categories{
  final String car = "car";
  final String eat = "eat";
  final String home = "home";
}
class OperationsTitleInfo{
  String? uid;
  String? accountId = '';
  String? author = '';
  String title= ''; 
  bool operationType= false;
  String count= '';
  DateTime? date = DateTime.now();

  OperationsTitleInfo({this.uid,  this.operationType = false, this.accountId, this.author = '',this.title = '',this.count = '', this.date});

  Map<String , dynamic> toMap(){
    return {
      "accountId" : accountId,
      "author" : author,
      "title": title,
      "operationType" : operationType,
      "count" : count,
      "date" : date,
    };
  }
  OperationsTitleInfo.fromJson(String uid,Map<String , dynamic> data){
    this.uid = uid;
    this.accountId = data["accountId"];
    this.author = data["author"];
    this.title = data["title"];
    this.operationType = data["operationType"];
    this.count = data["count"];
    this.date = DateTime.now();
  }
}