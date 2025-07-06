import 'package:equatable/equatable.dart';
import '../../../rest_clients/model/address/address_model.dart';

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> images;
  final List<AddressModel> addresses;

  const HomeLoaded({required this.images, required this.addresses});

  @override
  List<Object?> get props => [images, addresses];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
