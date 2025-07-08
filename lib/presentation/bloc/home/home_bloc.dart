import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/data/rest_clients/dtos/address/address_dto.dart';
import 'package:icondo/data/services/home_data/home_data_service_impl.dart';
import 'package:icondo/presentation/bloc/home/home_event.dart';
import 'package:icondo/presentation/bloc/home/home_state.dart';

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeDataServiceImpl _homeDataService;

  HomeBloc({required HomeDataServiceImpl homeRepositoryImpl})
    : _homeDataService = homeRepositoryImpl,
      super(HomeInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<RefreshData>(_onRefreshData);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final data = await _homeDataService.getInitialDataWithErrorHandling();

      emit(
        HomeLoaded(
          images: data['images'] as List<String>,
          addresses: data['addresses'] as List<AddressDto>,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshData(
    RefreshData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final data = await _homeDataService.getInitialDataWithErrorHandling();

      emit(
        HomeLoaded(
          images: data['images'] as List<String>,
          addresses: data['addresses'] as List<AddressDto>,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
