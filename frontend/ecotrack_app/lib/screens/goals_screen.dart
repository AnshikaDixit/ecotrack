import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goals_provider.dart';
import '../widgets/goal_card.dart';
import '../widgets/create_goal_dialog.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  GoalsScreenState createState() => GoalsScreenState();
}

class GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GoalsProvider>(context, listen: false).fetchGoals();
    });
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => const CreateGoalDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GoalsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.goals.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchGoals(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          final goals = provider.goals;

          if (goals.isEmpty) {
            return const Center(child: Text('No active goals. Set a new goal!'));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchGoals,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                return GoalCard(goal: goals[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
