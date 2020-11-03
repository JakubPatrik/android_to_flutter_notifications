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
      id: json['data']['message_id'],
      title: json['data']['title'],
      body: json['data']['body'],
      image: json['data']['image'],
    );
  }

  Map<String, String> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "body": this.body,
      "image": this.image,
    };
  }
}
