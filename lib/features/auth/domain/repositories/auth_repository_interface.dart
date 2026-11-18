import 'package:get/get.dart';

abstract class AuthRepositoryInterface {
  Future<Response> login(String username, String password);

  Future<Response> logout();

  Future<Response> getMe();

  Future<bool> saveToken(String token);

  String? getToken();

  Future<bool> clearToken();

  Future<void> saveCredentials(String username, String password);

  Future<void> clearCredentials();

  String getUserName();

  String getUserPassword();
}
