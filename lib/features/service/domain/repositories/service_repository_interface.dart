import 'package:get/get.dart';

abstract class ServiceRepositoryInterface {
  Future<Response> getServices();
}
