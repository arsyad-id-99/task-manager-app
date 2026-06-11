import 'package:dartz/dartz.dart' as dartz;
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';

class UpdateTaskStatus {
  final TaskRepository repository;
  UpdateTaskStatus(this.repository);

  Future<dartz.Either<Failure, void>> call(String id, bool isDone) async {
    return await repository.updateTaskStatus(id, isDone);
  }
}
