class FootprintSummary {
  final double totalCo2eKg;
  final Map<String, double> categoryBreakdown;
  final int ecoPoints;

  FootprintSummary({
    required this.totalCo2eKg,
    required this.categoryBreakdown,
    this.ecoPoints = 0,
  });

  factory FootprintSummary.fromJson(Map<String, dynamic> json) {
    return FootprintSummary(
      totalCo2eKg: (json['total_co2e_kg'] as num).toDouble(),
      categoryBreakdown: (json['category_breakdown'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      ecoPoints: json['eco_points'] as int? ?? 0,
    );
  }
}
