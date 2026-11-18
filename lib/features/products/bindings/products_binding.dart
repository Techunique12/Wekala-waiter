import 'package:get/get.dart';
import 'package:wekala_waiter/features/products/controllers/products_controller.dart';
import 'package:wekala_waiter/features/products/domain/repositories/products_repository.dart';
import 'package:wekala_waiter/features/products/domain/repositories/products_repository_interface.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsRepositoryInterface>(
      () => ProductsRepository(apiClient: Get.find()),
    );

    Get.lazyPut<ProductsController>(
      () => ProductsController(
        productsRepository: Get.find<ProductsRepositoryInterface>(),
      ),
    );
  }
}
