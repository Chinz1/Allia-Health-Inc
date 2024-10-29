class Option {
  final int id;
  final int questionId;
  final String option;
  final bool isFreeForm;

  Option({
    required this.id,
    required this.questionId,
    required this.option,
    required this.isFreeForm,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      questionId: json['questionId'],
      option: json['option'],
      isFreeForm: json['isFreeForm'],
    );
  }
}
