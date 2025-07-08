import 'package:icondo/data/rest_clients/dtos/address/address_dto.dart';

abstract class HomeDataService {
  Future<List<String>> getImages();

  Future<List<AddressDto>> getAddresses();

  Future<Map<String, dynamic>> getInitialData();

  Future<Map<String, dynamic>> getInitialDataWithTimeout({
    Duration timeout = const Duration(seconds: 30),
  });

  Future<Map<String, dynamic>> getInitialDataWithErrorHandling();
}
