class NoteTitleInfo {
  String? uid;
  String? author = '';
  String title = "";
  String description = "";
  NoteTitleInfo({this.uid , this.author, this.title = '', this.description = ''});
  Map<String, dynamic> toMap() {
    return {
      "author": author,
      "title": title,
      "description": description,
    };
  }

  Map<String, dynamic> toNoteMap() {
    return {
      "author": author,
      "title": title,
      "description": description.length <= 100? description : description.substring(0, 100),
    };
  }

  NoteTitleInfo.fromJson(String uid, Map<String, dynamic> data) {
    this.uid = uid;
    this.author = data["author"];
    this.title = data["title"];
    this.description = data["description"];
  }
}
