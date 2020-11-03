class Notification {
  final String id;
  final String title;
  final String body;
  final String image;

  Notification({
    this.id,
    this.title,
    this.body,
    this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
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
