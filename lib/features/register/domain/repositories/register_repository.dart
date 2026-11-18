import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/register/domain/models/register_check_model.dart';
import 'package:wekala_waiter/features/register/domain/repositories/register_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class RegisterRepository implements RegisterRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  RegisterRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Response> checkCashRegister() async {
    Response response = await apiClient.getData(
      AppConstants.checkRegisterUri,
      showError: false,
    );
    return response;
  }

  @override
  Future<Response> openCashRegister(int locationId, double amount) async {
    Response response = await apiClient.postData(AppConstants.openRegisterUri, {
      "location_id": locationId,
      "amount": amount,
    });
    return response;
  }

  @override
  Future<Response> closeCashRegister(
    int userId,
    double closingAmount,
    int totalCardSlips,
    int totalCheques,
    String? closingNote,
  ) async {
    Response response = await apiClient
        .postData(AppConstants.closeRegisterUri, {
          "user_id": userId,
          "closing_amount": closingAmount,
          "total_card_slips": totalCardSlips,
          "total_cheques": totalCheques,
          "closing_note": closingNote,
        });
    return response;
  }

  @override
  Future<Response> getCashRegisterCloseData(int id) async {
    Response response = await apiClient.getData(
      '${AppConstants.closeRegisterDataUri}/$id',
    );
    return response;
  }

  @override
  Future<void> saveCashRegisterData(RegisterCheckData register) async {
    await sharedPreferences.setString(
      AppConstants.cashRegisterData,
      jsonEncode(register.toJson()),
    );

    debugPrint(
      '======== CashRegisterData ========\n'
      '${register.toJson()}',
    );
  }

  @override
  Future<void> removeCashRegisterData() async {
    await sharedPreferences.remove(AppConstants.cashRegisterData);
  }

  @override
  RegisterCheckData? getCashRegisterData() {
    final local = sharedPreferences.getString(AppConstants.cashRegisterData);

    if (local == null || local.isEmpty) {
      return null;
    }

    try {
      return RegisterCheckData.fromJson(jsonDecode(local));
    } catch (e) {
      debugPrint('Error reading cash register data: $e');
      return null;
    }
  }
}
