import 'package:get/get_connect/http/src/response/response.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/customer/domain/repositories/customer_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class CustomerRepository implements CustomerRepositoryInterface {
  final ApiClient apiClient;
  CustomerRepository({required this.apiClient});

  @override
  Future<Response> searchCustomers(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);

    Response response = await apiClient.getData(
      '${AppConstants.searchCustomersUri}?q=$encodedQuery',
    );
    return response;
  }

  @override
  Future<Response> getCustomerDue(int contactId) async {
    Response response = await apiClient.getData(
      AppConstants.getCustomerDueUri(contactId),
    );
    return response;
  }
}
