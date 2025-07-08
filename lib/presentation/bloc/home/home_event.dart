import 'package:equatable/equatable.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends HomeEvent {}

class RefreshData extends HomeEvent {}
