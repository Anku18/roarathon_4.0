import 'dart:convert';

enum NotificationType { marketAlert, streak, mission, referral, general }

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  String get typeIcon {
    switch (type) {
      case NotificationType.marketAlert:
        return '📈';
      case NotificationType.streak:
        return '🔥';
      case NotificationType.mission:
        return '🎯';
      case NotificationType.referral:
        return '👥';
      case NotificationType.general:
        return '🔔';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  static List<AppNotification> listFromJsonString(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<AppNotification> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }
}
