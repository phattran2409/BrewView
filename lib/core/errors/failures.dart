import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(String message , {String? code}) : super(message , code: code);

}

class NetworkFailure extends Failure {
  const NetworkFailure([String message ="Network error occurred", String? code]) : super(message , code: code);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error', String? code])
      : super(message, code: code);
}
