import 'package:equatable/equatable.dart';
import 'package:task_manager_app/domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String id;
  final bool isDone;
  const UpdateTaskStatusEvent({required this.id, required this.isDone});

  @override
  List<Object?> get props => [id, isDone];
}
