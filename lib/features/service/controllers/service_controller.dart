import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/service/domain/models/service_model.dart';
import 'package:wekala_waiter/features/service/domain/repositories/service_repository_interface.dart';

class ServiceController extends GetxController {
  final ServiceRepositoryInterface serviceRepository;

  ServiceController({required this.serviceRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  Future<void> getServices() async {
    _isLoading = true;
    update();

    try {
      final registerController = Get.find<RegisterController>();
      final registerData = registerController.currentRegister;

      if (registerData == null ||
          registerData.businessId == null ||
          registerData.locationId == null) {
        _services = [];
        return;
      }

      final businessId = registerData.businessId!;
      final locationId = registerData.locationId!;

      final Response response = await serviceRepository.getServices();

      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];

        _services = data
            .map((e) => ServiceModel.fromJson(e))
            .where(
              (element) =>
                  element.businessId == businessId &&
                  element.locationPriceGroup.containsKey(locationId.toString()),
            )
            .toList()
            .reversed
            .toList();

        debugPrint('Services loaded: ${_services.length}');
      } else {
        debugPrint('Error getting services: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting services: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getServices();
  }
}
