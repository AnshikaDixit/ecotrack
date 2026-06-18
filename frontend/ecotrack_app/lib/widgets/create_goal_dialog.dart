import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goals_provider.dart';

class CreateGoalDialog extends StatefulWidget {
  const CreateGoalDialog({super.key});

  @override
  CreateGoalDialogState createState() => CreateGoalDialogState();
}

class CreateGoalDialogState extends State<CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _baselineController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<GoalsProvider>(context, listen: false);
      final success = await provider.createGoal({
        'title': _titleController.text,
        'target_reduction_percent': double.parse(_targetController.text),
        'baseline_co2e_kg': double.parse(_baselineController.text),
        'period_start': _startDate.toIso8601String(),
        'period_end': _endDate.toIso8601String(),
      });

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal created successfully!'), backgroundColor: Colors.green),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Failed to create goal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set a New Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Goal Title (e.g. Diet Change)'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(labelText: 'Target Reduction (%)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Must be a number' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _baselineController,
                decoration: const InputDecoration(labelText: 'Baseline Emissions (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val == null || double.tryParse(val) == null ? 'Must be a number' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Start Date'),
                        child: Text('${_startDate.toLocal()}'.split(' ')[0]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'End Date'),
                        child: Text('${_endDate.toLocal()}'.split(' ')[0]),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}
