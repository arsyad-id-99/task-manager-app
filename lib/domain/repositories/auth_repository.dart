import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, String>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, void>> logout();
  Future<bool> isLoggedIn();
}
