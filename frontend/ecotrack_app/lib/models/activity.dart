class Activity {
  final int? id;
  final String category;
  final String subtype;
  final double quantity;
  final String unit;
  final DateTime activityDate;
  final double? co2eKg;

  Activity({
    this.id,
    required this.category,
    required this.subtype,
    required this.quantity,
    required this.unit,
    required this.activityDate,
    this.co2eKg,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      category: json['category'],
      subtype: json['subtype'],
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'],
      activityDate: DateTime.parse(json['activity_date']),
      co2eKg: json['co2e_kg'] != null ? (json['co2e_kg'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subtype': subtype,
      'quantity': quantity,
      'unit': unit,
      'activity_date': activityDate.toIso8601String(),
    };
  }
}
