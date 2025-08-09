
import '../model/user.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final bool isLoading;
  final List<User> users; 
  final String? error;
  
  const UserState({
    this.isLoading = false,
    this.users = const [],
    this.error,
  }); 

  UserState copyWith({bool? isLoading, List<User>? users, String? error}) =>
      UserState(
        isLoading: isLoading ?? this.isLoading,
        users: users ?? this.users,
        error: error,
      );

  @override
  List<Object?> get props => [isLoading, users, error];
} 