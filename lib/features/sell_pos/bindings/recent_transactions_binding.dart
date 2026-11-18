import 'package:get/get.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/recent_transactions_controller.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository_interface.dart';

class RecentTransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PosRepositoryInterface>(
      () => PosRepository(apiClient: Get.find()),
    );

    Get.lazyPut<RecentTransactionsController>(
      () => RecentTransactionsController(
        posRepository: Get.find<PosRepositoryInterface>(),
      ),
    );
  }
}
