import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:wekala_waiter/helper/device_helper.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<Response> login(String username, String password) async {
    final deviceName = await DeviceHelper.getDeviceName();
    return apiClient.postData(AppConstants.loginUri, {
      "username": username,
      "password": password,
      "device_name": deviceName,
    }, handleError: false);
  }

  @override
  Future<Response> logout() {
    return apiClient.postData(AppConstants.logoutUri, {}, handleError: false);
  }

  @override
  Future<Response> getMe() {
    return apiClient.getData(AppConstants.meUri, handleError: false);
  }

  @override
  Future<bool> saveToken(String token) {
    apiClient.updateHeader(token);
    return sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  String? getToken() {
    return sharedPreferences.getString(AppConstants.token);
  }

  @override
  Future<bool> clearToken() {
    apiClient.updateHeader(null);
    return sharedPreferences.remove(AppConstants.token);
  }

  @override
  Future<void> saveCredentials(String username, String password) {
    return Future.wait([
      sharedPreferences.setString(AppConstants.userNameKey, username),
      sharedPreferences.setString(AppConstants.passwordKey, password),
    ]);
  }

  @override
  Future<void> clearCredentials() {
    return Future.wait([
      sharedPreferences.remove(AppConstants.userNameKey),
      sharedPreferences.remove(AppConstants.passwordKey),
    ]);
  }

  @override
  String getUserName() {
    String? username = sharedPreferences.getString(AppConstants.userNameKey);
    return username ?? '';
  }

  @override
  String getUserPassword() {
    String? password = sharedPreferences.getString(AppConstants.passwordKey);
    return password ?? '';
  }
}
