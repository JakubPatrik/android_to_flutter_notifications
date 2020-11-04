class NotificationModel {
  final String id;
  final String created;
  final String title;
  final String body;
  final String image;

  NotificationModel({
    this.id,
    this.created,
    this.title,
    this.body,
    this.image,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String date = json['created'] != null ? json['created'].toString() : "null";
    return NotificationModel(
      id: json['message_id'].toString(),
      created: date,
      title: json['title'],
      body: json['body'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message_id": this.id,
      "created": this.created,
      "title": this.title,
      "body": this.body,
      "image": this.image,
    };
  }
}
