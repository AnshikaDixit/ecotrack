import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/activity_provider.dart';
import '../providers/dashboard_provider.dart';

class LogActivityScreen extends StatefulWidget {
  const LogActivityScreen({super.key});

  @override
  LogActivityScreenState createState() => LogActivityScreenState();
}

class LogActivityScreenState extends State<LogActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedCategory = 'Transport';
  String _selectedSubtype = 'Car, petrol (avg)';
  final _quantityController = TextEditingController();
  String _selectedUnit = 'km';
  DateTime _selectedDate = DateTime.now();

  final Map<String, List<String>> _categorySubtypes = {
    'Transport': ['Car, petrol (avg)', 'Car, diesel (avg)', 'Two-wheeler', 'Bus', 'Train/Metro', 'Domestic flight', 'Bicycle/Walk'],
    'Energy': ['Electricity (India grid, default)', 'LPG cooking gas'],
    'Food': ['Vegan diet', 'Vegetarian diet', 'Omnivore (avg) diet', 'High-meat diet'],
    'Waste': ['Landfill', 'Recycled'],
  };

  final Map<String, List<String>> _categoryUnits = {
    'Transport': ['km'],
    'Energy': ['kWh', 'kg'],
    'Food': ['day'],
    'Waste': ['kg'],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
      
      final activity = Activity(
        category: _selectedCategory,
        subtype: _selectedSubtype,
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        activityDate: _selectedDate,
      );

      final success = await activityProvider.logActivity(activity);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Activity Logged! +10 Eco Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Great job making sustainable choices.', style: TextStyle(color: Colors.grey.shade200, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );
        _quantityController.clear();
        // Refresh dashboard data
        Provider.of<DashboardProvider>(context, listen: false).fetchData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(activityProvider.errorMessage ?? 'Failed to log activity')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log New Activity', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Category Dropdown
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  items: _categorySubtypes.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      _selectedSubtype = _categorySubtypes[_selectedCategory]!.first;
                      _selectedUnit = _categoryUnits[_selectedCategory]!.first;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtype Dropdown
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Subtype', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedSubtype,
                  items: _categorySubtypes[_selectedCategory]!.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubtype = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quantity and Unit row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedUnit,
                        items: _categoryUnits[_selectedCategory]!.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedUnit = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Date Picker
            Semantics(
              label: 'Select Activity Date. Current date is ${_selectedDate.toLocal()}'.split(' ')[0],
              button: true,
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Activity Date', border: OutlineInputBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: activityProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Log Activity'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
