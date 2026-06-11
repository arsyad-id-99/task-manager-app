import 'package:dio/dio.dart';
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/core/network/api_config.dart';
import 'package:task_manager_app/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> addTask(TaskModel task);
  Future<void> updateTask(String id, bool isDone);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio dio;
  TaskRemoteDataSourceImpl({required this.dio});

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      final response = await dio.post(
        '${ApiConfig.baseUrl}/tasks',
        data: {'title': task.title, 'description': task.description},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await dio.get('${ApiConfig.baseUrl}/tasks');

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<void> updateTask(String id, bool isDone) async {
    try {
      await dio.patch(
        '${ApiConfig.baseUrl}/tasks/$id/status',
        data: {'status': isDone ? 'done' : 'todo'},
      );
    } on DioException {
      throw ServerException();
    }
  }
}
