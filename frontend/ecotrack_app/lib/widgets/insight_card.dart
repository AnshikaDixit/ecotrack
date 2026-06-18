import 'package:flutter/material.dart';
import '../models/insight.dart';

class InsightCard extends StatelessWidget {
  final Insight insight;

  const InsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (insight.category) {
      case 'Transport':
        iconData = Icons.directions_car;
        iconColor = Colors.orange;
        break;
      case 'Energy':
        iconData = Icons.bolt;
        iconColor = Colors.blue;
        break;
      case 'Food':
        iconData = Icons.restaurant;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.lightbulb_outline;
        iconColor = Colors.amber;
    }

    return Semantics(
      container: true,
      label: 'Insight: ${insight.trigger}. ${insight.recommendation}${insight.estimatedSavingsKg != null ? '. Potential savings: ${insight.estimatedSavingsKg} kilograms' : ''}',
      child: Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.trigger,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight.recommendation,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  if (insight.estimatedSavingsKg != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Potential savings: ${insight.estimatedSavingsKg!.toStringAsFixed(1)} kg CO₂e',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
