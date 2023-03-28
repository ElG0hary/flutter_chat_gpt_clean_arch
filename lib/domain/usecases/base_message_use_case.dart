import 'package:chatgptwizzard/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseMessageUseCaseParameter<T, String> {
  Future<Either<Failure, T>> call(String message,String modelId);
}

