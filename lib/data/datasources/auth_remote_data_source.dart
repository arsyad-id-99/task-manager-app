import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_config.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<String> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConfig.baseUrl}/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<String> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConfig.baseUrl}/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data['token'];
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }
}
