class QuestionsResponse {
  final List<String> questions;

  QuestionsResponse({required this.questions});

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) {
    // Debugging: Print the JSON
    print('Parsing JSON: $json');

    // Navigate through the nested structure
    final nestedQuestions = json['questions']?['questions'];

    // Check if it's a valid list
    if (nestedQuestions is List) {
      return QuestionsResponse(
        questions: List<String>.from(nestedQuestions),
      );
    }

    throw Exception('Invalid format for questions field');
  }

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
    };
  }
}
