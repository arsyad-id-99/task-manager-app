import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/auth_local_data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final token = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(token);
      return Right(token);
    } on ServerException {
      return Left(ServerFailure('Gagal melakukan login. Periksa kredensial.'));
    }
  }

  @override
  Future<Either<Failure, String>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final token = await remoteDataSource.register(name, email, password);
      await localDataSource.saveToken(token);
      return Right(token);
    } on ServerException {
      return Left(ServerFailure('Gagal melakukan registrasi.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Gagal logout'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    return token != null;
  }
}
