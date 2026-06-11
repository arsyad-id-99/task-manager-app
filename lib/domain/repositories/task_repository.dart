import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/domain/entities/task.dart';

abstract class TaskRepository {
  Future<dartz.Either<Failure, Task>> addTask(Task task);
  Future<dartz.Either<Failure, void>> updateTaskStatus(String id, bool isDone);
  Future<dartz.Either<Failure, List<Task>>> getTasks();
}
