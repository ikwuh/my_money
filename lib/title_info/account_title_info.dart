class AccountTitleInfo{
  String? uid;
  String? author = '';
  String title = ''; 
  String balance = '';

  AccountTitleInfo({this.uid, this.author = '', this.title = '', this.balance = ''});
  Map<String , dynamic> toMap(){

    return {
      "author" : author,
      "title": title,
      "balance" : balance,
    };
  }
  AccountTitleInfo.fromJson(String uid,Map<String , dynamic> data){
    this.uid = uid;
    this.author = data["author"];
    this.title = data["title"];
    this.balance = data["balance"];
  }
}