import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/api_request_status.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/features/auth/domain/models/user_model.dart';
import 'package:wekala_waiter/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:wekala_waiter/helper/route_helper.dart';

class AuthController extends GetxController {
  final AuthRepositoryInterface authRepository;

  AuthController({required this.authRepository});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isRememberMe = false;
  bool get isRememberMe => _isRememberMe;
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await authRepository.login(username, password);

      if (response.statusCode == 200) {
        final data = response.body['data'];

        await authRepository.saveToken(data['token']);

        _user = UserModel.fromJson(data['user']);

        if (_isRememberMe) {
          await authRepository.saveCredentials(username, password);
        } else {
          await authRepository.clearCredentials();
        }

        Get.offAllNamed(RouteHelper.registerCheck);
      } else {
        debugPrint('Login error: ${response.body}');
        showCustomSnackBar(
          response.body is Map
              ? response.body['message'] ?? 'Login failed'
              : 'Login failed',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error login: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      update();
    }
  }

  void toggleRememberMe() {
    _isRememberMe = !_isRememberMe;
    update();
  }

  bool isLoggedIn() {
    String? token = authRepository.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<ApiRequestStatus> getMe() async {
    if (_isLoading) return ApiRequestStatus.error;

    _isLoading = true;
    update();

    try {
      final Response response = await authRepository.getMe();

      if (response.statusCode == 200) {
        _user = UserModel.fromJson(response.body['data']);
        return ApiRequestStatus.success;
      }

      if (response.statusCode == 401) {
        return ApiRequestStatus.unauthorized;
      }

      if (response.statusCode == 0) {
        return ApiRequestStatus.noInternet;
      }

      if (response.statusCode == -1) {
        return ApiRequestStatus.timeout;
      }

      return ApiRequestStatus.error;
    } catch (e) {
      debugPrint('Error getting user: $e');

      return ApiRequestStatus.error;
    } finally {
      _isLoading = false;
      update();
    }
  }

  String getUserName() {
    return authRepository.getUserName();
  }

  String getUserPassword() {
    return authRepository.getUserPassword();
  }

  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await authRepository.logout();

      if (response.statusCode == 200 || response.statusCode == 401) {
        await authRepository.clearToken();

        _user = null;

        Get.offAllNamed(RouteHelper.signIn);
      } else {
        debugPrint(
          'Error logout: '
          '${response.body?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      debugPrint('Error logout: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  void clearSession() {
    authRepository.clearToken();
    _user = null;

    Get.offAllNamed(RouteHelper.signIn);
  }
}
