part of 'swipe_bloc.dart';
// import 'package:equatable/equatable.dart';

abstract class SwipeState extends Equatable {
  const SwipeState();

  @override
  List<Object> get props => [];
}

class SwipeLoading extends SwipeState {}

class SwipeLoaded extends SwipeState {
  final List<User> users;

  const SwipeLoaded({
    required this.users,
  });

  @override
  List<Object> get props => [users];
}

class SwipeError extends SwipeState {}

class SwipeMatched extends SwipeState {
  final User user;
  SwipeMatched({required this.user});

  @override
  List<Object> get props => [user];
}
