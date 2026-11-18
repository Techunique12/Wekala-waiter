import 'package:get/get.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository_interface.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosRepositoryInterface>(
      () => PosRepository(apiClient: Get.find()),
    );

    Get.lazyPut<PosController>(
      () => PosController(posRepository: Get.find<PosRepositoryInterface>()),
    );
  }
}
