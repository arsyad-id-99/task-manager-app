import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../pages/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
          );
        },
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            if (value != null) {
              context.read<TaskBloc>().add(
                UpdateTaskStatusEvent(id: task.id, isDone: value),
              );
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          task.isDone ? Icons.check_circle : Icons.pending,
          color: task.isDone ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
