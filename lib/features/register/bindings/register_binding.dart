// import 'package:get/get.dart';
// import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
// import 'package:wekala_waiter/features/register/domain/repositories/register_repository.dart';
// import 'package:wekala_waiter/features/register/domain/repositories/register_repository_interface.dart';

// class RegisterBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<RegisterRepositoryInterface>(
//       () => RegisterRepository(
//         apiClient: Get.find(),
//         sharedPreferences: Get.find(),
//       ),
//       fenix: true,
//     );

//     Get.lazyPut<RegisterController>(
//       () => RegisterController(
//         registerRepository: Get.find<RegisterRepositoryInterface>(),
//       ),
//       fenix: true,
//     );
//   }
// }
