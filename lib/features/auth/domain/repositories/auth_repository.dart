import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthSessionEntity?>> getCachedSession();

  Future<Either<Failure, AuthSessionEntity>> verifySession();

  Future<Either<Failure, void>> logout();
}
