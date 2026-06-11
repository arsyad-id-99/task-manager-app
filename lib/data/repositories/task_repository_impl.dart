import 'package:dartz/dartz.dart' hide Task;
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/data/datasources/task_remote_data_source.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/domain/entities/task.dart';
import 'package:task_manager_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Task>> addTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isDone: task.isDone,
      );
      final addedTask = await remoteDataSource.addTask(taskModel);
      return Right(addedTask);
    } on ServerException {
      return Left(ServerFailure('Failed to add task'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final taskModels = await remoteDataSource.getTasks();
      return Right(taskModels);
    } on ServerException {
      return Left(ServerFailure('Failed to get tasks'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTaskStatus(String id, bool isDone) async {
    try {
      await remoteDataSource.updateTask(id, isDone);
      return Right(null);
    } on ServerException {
      return Left(ServerFailure('Failed to update task status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
