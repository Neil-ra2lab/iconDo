import '../../rest_clients/model/address/address_model.dart';

abstract class HomeRepository {
  Future<List<String>> getImages();

  Future<List<AddressModel>> getAddresses();

  Future<Map<String, dynamic>> getInitialData();

  Future<Map<String, dynamic>> getInitialDataWithTimeout({
    Duration timeout = const Duration(seconds: 30),
  });

  Future<Map<String, dynamic>> getInitialDataWithErrorHandling();
}
