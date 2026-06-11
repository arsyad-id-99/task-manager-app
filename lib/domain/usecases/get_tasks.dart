import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<dartz.Either<Failure, List<Task>>> call() async {
    return await repository.getTasks();
  }
}
