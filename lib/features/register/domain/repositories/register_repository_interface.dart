import 'package:get/get.dart';
import 'package:wekala_waiter/features/register/domain/models/register_check_model.dart';

abstract class RegisterRepositoryInterface {
  Future<Response> checkCashRegister();
  Future<Response> openCashRegister(int locationId, double amount);
  Future<Response> closeCashRegister(
    int userId,
    double closingAmount,
    int totalCardSlips,
    int totalCheques,
    String? closingNote,
  );
  Future<Response> getCashRegisterCloseData(int id);
  Future<void> saveCashRegisterData(RegisterCheckData register);
  Future<void> removeCashRegisterData();
  RegisterCheckData? getCashRegisterData();
}
