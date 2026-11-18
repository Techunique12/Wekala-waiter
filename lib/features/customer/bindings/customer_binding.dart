import 'package:get/get.dart';
import 'package:wekala_waiter/features/customer/controllers/customer_controller.dart';
import 'package:wekala_waiter/features/customer/domain/repositories/customer_repository.dart';
import 'package:wekala_waiter/features/customer/domain/repositories/customer_repository_interface.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerRepositoryInterface>(
      () => CustomerRepository(apiClient: Get.find()),
    );

    Get.lazyPut<CustomerController>(
      () => CustomerController(
        customerRepository: Get.find<CustomerRepositoryInterface>(),
      ),
    );
  }
}
