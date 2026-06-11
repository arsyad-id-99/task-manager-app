// lib/presentation/widgets/task_empty_state.dart
import 'package:flutter/material.dart';
import '../pages/add_task_page.dart';

class TaskEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const TaskEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF174DB1);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_turned_in_rounded,
                size: 80,
                color: themeColor,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'All tasks you create will appear here. Start by adding a new task to keep track of your daily activities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskPage()),
                );
                onRefresh();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Create New Task',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
