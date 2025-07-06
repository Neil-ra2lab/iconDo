import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:icondo/rest_clients/model/address/address_model.dart';

part 'home_clients.g.dart';

@RestApi()
abstract class HomeClients {
  factory HomeClients(Dio dio, {required String baseUrl}) = _HomeClients;

  @GET('v1/a5d4cf16-1f36-4f2b-b5cd-89772a83e999')
  Future<List<String>> getImages();

  @GET('v1/b9607fd2-bd7a-484e-917f-a5e641ec6cc9')
  Future<List<AddressModel>> getAddresses();
}
