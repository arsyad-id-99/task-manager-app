import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<dartz.Either<Failure, Task>> call(Task task) async {
    return await repository.addTask(task);
  }
}
