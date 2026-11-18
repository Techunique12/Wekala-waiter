import 'package:get/get_connect/http/src/response/response.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/service/domain/repositories/service_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class ServiceRepository implements ServiceRepositoryInterface {
  final ApiClient apiClient;
  ServiceRepository({required this.apiClient});
  @override
  Future<Response> getServices() async {
    Response response = await apiClient.getData(
      AppConstants.typesOfServiceUri,
      showError: false,
    );
    return response;
  }
}
