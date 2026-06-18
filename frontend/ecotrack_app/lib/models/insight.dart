class Insight {
  final String category;
  final String trigger;
  final String recommendation;
  final double? estimatedSavingsKg;
  final String insightKey;

  Insight({
    required this.category,
    required this.trigger,
    required this.recommendation,
    this.estimatedSavingsKg,
    required this.insightKey,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      category: json['category'],
      trigger: json['trigger'],
      recommendation: json['recommendation'],
      estimatedSavingsKg: json['estimated_savings_kg'] != null ? (json['estimated_savings_kg'] as num).toDouble() : null,
      insightKey: json['insight_key'],
    );
  }
}
