import 'package:equatable/equatable.dart';

class QueryResult extends Equatable {
  final String title;
  final String content;
  final DateTime timestamp;

  const QueryResult({
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory QueryResult.fromJson(Map<String, dynamic> json) {
    return QueryResult(
      title: json['title'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  List<Object?> get props => [title, content, timestamp];
}
