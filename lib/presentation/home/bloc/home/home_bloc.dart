import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icondo/data/respositories/home_respositories_imp.dart';
import 'package:icondo/rest_clients/model/address/address_model.dart';
import 'home_event.dart';
import 'home_state.dart';

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepositoryImpl _homeRepositoryImpl;

  HomeBloc({required HomeRepositoryImpl homeRepositoryImpl})
    : _homeRepositoryImpl = homeRepositoryImpl,
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
      final data = await _homeRepositoryImpl.getInitialDataWithErrorHandling();

      emit(
        HomeLoaded(
          images: data['images'] as List<String>,
          addresses: data['addresses'] as List<AddressModel>,
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
      final data = await _homeRepositoryImpl.getInitialDataWithErrorHandling();

      emit(
        HomeLoaded(
          images: data['images'] as List<String>,
          addresses: data['addresses'] as List<AddressModel>,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
