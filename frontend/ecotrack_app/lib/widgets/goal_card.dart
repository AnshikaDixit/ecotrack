import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.status == 'completed' || goal.progressPercent >= 1.0;
    final progress = goal.progressPercent;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shadowColor: isCompleted ? Colors.amber.withValues(alpha: 0.4) : Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCompleted 
            ? LinearGradient(colors: [Colors.white, Colors.amber.shade50], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.amber.shade300, Colors.amber.shade500]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Crushed! 🏆', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Target: Reduce by ${goal.targetReductionPercent}%', style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Baseline: ${goal.baselineCo2eKg} kg', style: TextStyle(color: Colors.grey.shade700)),
                Text('Current: ${goal.currentCo2eKg.toStringAsFixed(1)} kg', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: goal.currentCo2eKg <= goal.targetCo2eKg ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutQuart,
              builder: (context, val, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: val,
                        backgroundColor: Colors.grey.shade200,
                        color: val >= 1.0 ? Colors.amber : Colors.blue,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(val * 100).toStringAsFixed(1)}% to goal',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
