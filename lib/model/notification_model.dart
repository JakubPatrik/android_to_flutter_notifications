class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String image;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.image,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['message_id'].toString(),
      title: json['title'],
      body: json['body'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message_id": this.id,
      "title": this.title,
      "body": this.body,
      "image": this.image,
    };
  }
}
