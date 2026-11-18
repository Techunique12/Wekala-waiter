import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';
import 'package:wekala_waiter/features/register/domain/models/register_close_model.dart';
import 'package:wekala_waiter/features/register/domain/models/register_check_model.dart';
import 'package:wekala_waiter/features/register/domain/repositories/register_repository_interface.dart';
import 'package:wekala_waiter/helper/route_helper.dart';

class RegisterController extends GetxController {
  final RegisterRepositoryInterface registerRepository;

  RegisterController({required this.registerRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RegisterCheckModel? _registerCheckModel;
  RegisterCheckModel? get registerCheckModel => _registerCheckModel;

  RegisterCloseDataResponse? _registerCloseData;
  RegisterCloseDataResponse? get registerCloseData => _registerCloseData;

  bool get isRegisterOpen {
    return _registerCheckModel?.data?.alreadyOpen ?? false;
  }

  RegisterCheckData? get currentRegister {
    return registerRepository.getCashRegisterData();
  }

  int? get currentRegisterId {
    return currentRegister?.id;
  }

  Future<bool> checkRegister() async {
    if (_isLoading) return false;

    _setLoading(true);

    try {
      return await _refreshRegisterState();
    } catch (e) {
      debugPrint('Error checking register: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> openCashRegister({
    required int locationId,
    required double amount,
  }) async {
    if (_isLoading) return false;

    _setLoading(true);

    try {
      final Response response = await registerRepository.openCashRegister(
        locationId,
        amount,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint(
          'Error opening register: '
          '${response.body?['message'] ?? 'Unknown error'}',
        );

        return false;
      }

      debugPrint('Register opened successfully');

      // Refresh register state from API.
      final checked = await _refreshRegisterState();

      if (checked && isRegisterOpen) {
        Get.offAllNamed(RouteHelper.initial);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error opening register: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> closeCashRegister({
    required double closingAmount,
    required int totalCardSlips,
    required int totalCheques,
    String? closingNote,
  }) async {
    if (_isLoading) return false;

    _setLoading(true);

    try {
      final authController = Get.find<AuthController>();

      final userId = authController.user?.id;

      if (userId == null) {
        debugPrint('User ID is null');
        return false;
      }

      final Response response = await registerRepository.closeCashRegister(
        userId,
        closingAmount,
        totalCardSlips,
        totalCheques,
        closingNote,
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Error closing register: '
          '${response.body?['message'] ?? 'Unknown error'}',
        );

        return false;
      }

      // Remove local register because it is now closed.
      await registerRepository.removeCashRegisterData();

      // Reset controller state.
      _registerCheckModel = null;
      _registerCloseData = null;

      Get.offAllNamed(RouteHelper.registerCheck);

      return true;
    } catch (e) {
      debugPrint('Error closing register: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register Close Details
  Future<bool> getCashRegisterCloseData() async {
    if (_isLoading) return false;

    _setLoading(true);

    try {
      final register = currentRegister;

      if (register?.id == null) {
        debugPrint('No current register found');
        return false;
      }

      final Response response = await registerRepository
          .getCashRegisterCloseData(register!.id!);

      if (response.statusCode != 200) {
        return false;
      }

      _registerCloseData = RegisterCloseDataResponse.fromJson(response.body);

      return true;
    } catch (e) {
      debugPrint('Error getting cash register close data: $e');

      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<bool> _refreshRegisterState() async {
    final Response response = await registerRepository.checkCashRegister();

    if (response.statusCode != 200) {
      return false;
    }

    final model = RegisterCheckModel.fromJson(response.body);

    _registerCheckModel = model;

    if (model.data?.alreadyOpen == true && model.data != null) {
      await registerRepository.saveCashRegisterData(model.data!);
    } else {
      await registerRepository.removeCashRegisterData();
    }

    return true;
  }
}
