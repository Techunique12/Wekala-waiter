import 'package:get/get.dart';

abstract class ProductsRepositoryInterface {
  Future<Response> getProducts(int locationId, {String? term, int page = 1});
}
