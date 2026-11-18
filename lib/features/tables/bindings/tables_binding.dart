import 'package:get/get.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/domain/repositories/tables_repository.dart';
import 'package:wekala_waiter/features/tables/domain/repositories/tables_repository_interface.dart';

class TablesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TablesRepositoryInterface>(
      () => TablesRepository(apiClient: Get.find()),
    );
    Get.lazyPut<TablesController>(
      () => TablesController(
        tablesRepository: Get.find<TablesRepositoryInterface>(),
      ),
    );
  }
}
