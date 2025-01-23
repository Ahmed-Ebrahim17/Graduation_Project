class SummaryResponse {
  final String id;
  final String summary;
  final String? title;

  SummaryResponse({
    required this.id,
    required this.summary,
    this.title,
  });

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      id: json['id'] ?? json['_id'] ?? '',
      summary: json['summary'] ?? '',
      title: json['title'],
    );
  }
}
