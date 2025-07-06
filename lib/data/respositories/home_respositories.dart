import '../../rest_clients/model/address/address_model.dart';

abstract class HomeRepository {
  Future<List<String>> getImages();

  Future<List<AddressModel>> getAddresses();
}
