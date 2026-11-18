import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/string_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/tables/domain/models/reserve_table_request.dart';
import 'package:wekala_waiter/features/tables/domain/models/table_model.dart';
import 'package:wekala_waiter/features/tables/domain/repositories/tables_repository_interface.dart';

class TablesController extends GetxController {
  final TablesRepositoryInterface tablesRepository;

  TablesController({required this.tablesRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _loadingAction;
  String? get loadingAction => _loadingAction;

  List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  Future<void> getTables() async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final registerController = Get.find<RegisterController>();

      final registerData = registerController.currentRegister;

      final locationId = registerData?.locationId;

      if (locationId == null) {
        debugPrint('Location ID not found');
        return;
      }

      final Response response = await tablesRepository.getTables(locationId);

      if (response.statusCode != 200) {
        return;
      }

      final data = response.body['data'] as List;
      _tables = data.map((e) => TableModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting tables: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> changeTable({
    required int transactionId,
    required int newTableId,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await tablesRepository.changeTable(
        transactionId,
        newTableId,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar('order_moved_successfully'.tr, isError: false);
      }
    } catch (e) {
      debugPrint('Error changing table: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> reserveTable({
    required int tableId,
    required ReserveTableRequest request,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await tablesRepository.reserveTables(
        tableId,
        request,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];

        if (data != null && data['booking_id'] != null) {
          Get.back();

          showCustomSnackBar(
            'reservation_created_successfully'.tr,
            isError: false,
          );

          return;
        }

        final message = response.body['message']?.toString().cleanHtml;

        showCustomSnackBar(message ?? 'something_went_wrong'.tr);
      }
    } catch (e) {
      debugPrint('Error reserving table: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> cancelReservation({required int bookingId}) async {
    _loadingAction = 'cancel_reservation';
    update();
    try {
      final Response response = await tablesRepository.cancelReservation(
        bookingId,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          'reservation_cancelled_successfully'.tr,
          isError: false,
        );
      }
    } catch (e) {
      debugPrint('Error cancel reservation: $e');
    } finally {
      _loadingAction = null;
      update();
    }
  }

  Future<void> checkInReservation({required int bookingId}) async {
    _loadingAction = 'checked_in';
    update();
    try {
      final Response response = await tablesRepository.checkInReservation(
        bookingId,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Reservation checked in successfully');

        final index = _tables.indexWhere(
          (table) => table.bookingId == bookingId,
        );

        if (index != -1) {
          _tables[index] = _tables[index].copyWith(isArrived: true);
        }
      }
    } catch (e) {
      debugPrint('Error checking in reservation: $e');
    } finally {
      _loadingAction = null;
      update();
    }
  }

  TableModel? getTableById(int tableId) {
    final index = _tables.indexWhere((table) => table.id == tableId);

    if (index == -1) return null;

    return _tables[index];
  }

  Future<ReserveTableRequest?> getReservation({required int bookingId}) async {
    try {
      final Response response = await tablesRepository.getReservation(
        bookingId,
      );
      if (response.statusCode == 200) {
        final data = response.body['data'];
        return ReserveTableRequest.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error geting reservation: $e');
    }
    return null;
  }

  Future<void> updateReservation({
    required int bookingId,
    required ReserveTableRequest request,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await tablesRepository.updateReservation(
        bookingId,
        request,
      );

      if (response.statusCode == 200) {
        Get.back();

        showCustomSnackBar(
          'reservation_updated_successfully'.tr,
          isError: false,
        );

        return;
      }
    } catch (e) {
      debugPrint('Error reserving table: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }
}
