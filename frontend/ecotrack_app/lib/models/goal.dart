class Goal {
  final int id;
  final String title;
  final double targetReductionPercent;
  final double baselineCo2eKg;
  final double currentCo2eKg;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String status;

  Goal({
    required this.id,
    required this.title,
    required this.targetReductionPercent,
    required this.baselineCo2eKg,
    required this.currentCo2eKg,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      targetReductionPercent: (json['target_reduction_percent'] as num).toDouble(),
      baselineCo2eKg: (json['baseline_co2e_kg'] as num).toDouble(),
      currentCo2eKg: (json['current_co2e_kg'] as num).toDouble(),
      periodStart: DateTime.parse(json['period_start']),
      periodEnd: DateTime.parse(json['period_end']),
      status: json['status'],
    );
  }

  double get targetCo2eKg {
    return baselineCo2eKg * (1 - (targetReductionPercent / 100));
  }

  double get progressPercent {
    if (baselineCo2eKg <= 0) return 0.0;
    final reduction = baselineCo2eKg - currentCo2eKg;
    final targetReduction = baselineCo2eKg - targetCo2eKg;
    if (targetReduction <= 0) return 0.0;
    return (reduction / targetReduction).clamp(0.0, 1.0);
  }
}
