class FeedbackModel {
  String id;
  String subject;
  String? content; // ? Bisa ada dan bis tidak ada

  // Register column
  FeedbackModel({required this.id, required this.subject, this.content});

  //1. Json to Model
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
        id: json['id'], subject: json['subject'], content: json['content']);
  }

  //2. Model To Json
  Map<String, dynamic> toJson() {
    return {"id": id, "subject, ": subject, "content": content};
  }
}
