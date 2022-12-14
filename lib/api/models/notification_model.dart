/// Model which represents the backend `Notification`-model.
class FrontendNotification {
  final int id;
  final bool seen;
  final String title;
  final String content;
  final DateTime createdAt;

  FrontendNotification({
    required this.id,
    required this.seen,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// Serializes a JSON-object into a Dart `Notification`-object with all properties.
  static FrontendNotification fromJSON(Map<String, dynamic> json) {
    return FrontendNotification(
      id: json['id'] as int,
      seen: json['seen'] as bool,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }

  /// Serializes a Dart `Notification`-object to a JSON-object with the attributes defined in
  /// the database.
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'seen': seen,
        'title': title,
        'content': content
      };

  /// Serializes a list JSON-objects into a list of Dart `Notification`-objects.
  static List<FrontendNotification> listFromJSON(List<dynamic> json) => (json)
      .map(
          (jsonNotification) => FrontendNotification.fromJSON(jsonNotification))
      .toList();
}
