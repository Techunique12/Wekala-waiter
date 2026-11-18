import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/core/localization/localization_controller.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';
import 'package:wekala_waiter/features/auth/domain/repositories/auth_repository.dart';
import 'package:wekala_waiter/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/register/domain/repositories/register_repository.dart';
import 'package:wekala_waiter/features/register/domain/repositories/register_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

Future<void> init() async {
  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut<SharedPreferences>(() => sharedPreferences);

  Get.put<LocalizationController>(
    LocalizationController(prefs: sharedPreferences),
    permanent: true,
  );

  Get.lazyPut<ApiClient>(
    () => ApiClient(
      appBaseUrl: AppConstants.baseUrl,
      sharedPreferences: Get.find<SharedPreferences>(),
    ),
  );

  /// Repositories
  Get.lazyPut<AuthRepositoryInterface>(
    () => AuthRepository(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>(),
    ),
  );

  Get.put<RegisterRepositoryInterface>(
    RegisterRepository(
      apiClient: Get.find<ApiClient>(),
      sharedPreferences: Get.find<SharedPreferences>(),
    ),
    permanent: true,
  );

  /// Controllers
  Get.put<AuthController>(
    AuthController(authRepository: Get.find<AuthRepositoryInterface>()),
    permanent: true,
  );

  Get.put<RegisterController>(
    RegisterController(
      registerRepository: Get.find<RegisterRepositoryInterface>(),
    ),
    permanent: true,
  );
}
