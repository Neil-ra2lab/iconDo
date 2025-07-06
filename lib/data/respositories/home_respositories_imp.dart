import 'package:icondo/data/respositories/home_respositories.dart';
import 'package:icondo/rest_clients/model/address/address_model.dart';
import 'package:icondo/rest_clients/clients/home/home_clients.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required this.homeClients});

  final HomeClients homeClients;
  Future<Map<String, dynamic>> getInitialData() async {
    try {
      final results = await Future.wait([
        homeClients.getImages(),
        homeClients.getAddresses(),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressModel>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  Future<Map<String, dynamic>> getInitialDataWithTimeout({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final results = await Future.wait([
        homeClients.getImages().timeout(timeout),
        homeClients.getAddresses().timeout(timeout),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressModel>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  Future<Map<String, dynamic>> getInitialDataWithErrorHandling() async {
    try {
      final results = await Future.wait([
        homeClients.getImages().catchError((error) {
          return <String>[];
        }),
        homeClients.getAddresses().catchError((error) {
          return <AddressModel>[];
        }),
      ]);

      return {
        'images': results[0] as List<String>,
        'addresses': results[1] as List<AddressModel>,
      };
    } catch (e) {
      throw Exception('Failed to load initial data: $e');
    }
  }

  @override
  Future<List<AddressModel>> getAddresses() {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getImages() {
    throw UnimplementedError();
  }
}
