class News {
  int? id;
  String? title;
  String? content;
  DateTime? publishDate;
  List<int>? image;
  bool? isDeleted;
  int? authorId;
  String? authorName;

  News({
    this.id,
    this.title,
    this.content,
    this.publishDate,
    this.image,
    this.isDeleted,
    this.authorId,
    this.authorName,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    publishDate = json['publishDate'] != null ? DateTime.parse(json['publishDate']) : null;
    image = json['image'] != null && json['image'] is List ? List<int>.from(json['image']) : null;
    isDeleted = json['isDeleted'];
    authorId = json['authorId'];
    authorName = json['authorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['publishDate'] = publishDate?.toIso8601String();
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['authorId'] = authorId;
    data['authorName'] = authorName;
    return data;
  }
} 