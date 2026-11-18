import 'package:get/get.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/service/controllers/service_controller.dart';
import 'package:wekala_waiter/features/service/domain/repositories/service_repository.dart';
import 'package:wekala_waiter/features/service/domain/repositories/service_repository_interface.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceRepositoryInterface>(
      () => ServiceRepository(apiClient: Get.find<ApiClient>()),
    );

    Get.lazyPut<ServiceController>(
      () => ServiceController(
        serviceRepository: Get.find<ServiceRepositoryInterface>(),
      ),
    );
  }
}
