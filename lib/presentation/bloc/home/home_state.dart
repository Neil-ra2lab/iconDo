import 'package:equatable/equatable.dart';
import 'package:icondo/data/rest_clients/dtos/address/address_dto.dart';

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
  final List<AddressDto> addresses;

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
