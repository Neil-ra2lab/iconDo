import 'package:icondo/data/rest_clients/clients/mocki/mocki_clients.dart';
import 'package:icondo/data/rest_clients/dtos/address/address_dto.dart';
import 'package:icondo/data/services/home_data/home_data_service.dart';

class HomeDataServiceImpl implements HomeDataService {
  const HomeDataServiceImpl({required this.mockiClient});

  final MockiClient mockiClient;

  @override
  Future<Map<String, dynamic>> getInitialData() async {
    try {
      final results = await Future.wait([
        mockiClient.getImages(),
        mockiClient.getAddresses(),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressDto>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getInitialDataWithTimeout({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final results = await Future.wait([
        mockiClient.getImages().timeout(timeout),
        mockiClient.getAddresses().timeout(timeout),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressDto>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getInitialDataWithErrorHandling() async {
    try {
      final results = await Future.wait([
        mockiClient.getImages().catchError((error) {
          return <String>[];
        }),
        mockiClient.getAddresses().catchError((error) {
          return <AddressDto>[];
        }),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressDto>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  @override
  Future<List<String>> getImages() async {
    try {
      return await mockiClient.getImages();
    } catch (e) {
      throw Exception('Failed to get images: $e');
    }
  }

  @override
  Future<List<AddressDto>> getAddresses() async {
    try {
      return await mockiClient.getAddresses();
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }
}
