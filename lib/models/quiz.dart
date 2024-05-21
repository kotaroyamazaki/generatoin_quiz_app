class Quiz {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;
  final List<String> tags;

  Quiz(
      {required this.question,
      required this.options,
      required this.answer,
      required this.explanation,
      required this.tags});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      explanation: json['explanation'],
      tags: List<String>.from(json['tags']),
    );
  }
}
