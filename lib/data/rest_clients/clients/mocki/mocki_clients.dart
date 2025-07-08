import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:icondo/data/rest_clients/dtos/address/address_dto.dart';

part 'mocki_clients.g.dart';

@RestApi()
abstract class MockiClient {
  factory MockiClient(Dio dio, {required String baseUrl}) = _MockiClient;

  @GET('v1/a5d4cf16-1f36-4f2b-b5cd-89772a83e999')
  Future<List<String>> getImages();

  @GET('v1/b9607fd2-bd7a-484e-917f-a5e641ec6cc9')
  Future<List<AddressDto>> getAddresses();
}
