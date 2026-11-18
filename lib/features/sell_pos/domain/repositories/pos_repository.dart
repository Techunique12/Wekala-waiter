import 'package:get/get_connect/http/src/response/response.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/sell_pos_request.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class PosRepository implements PosRepositoryInterface {
  final ApiClient apiClient;

  PosRepository({required this.apiClient});

  @override
  Future<Response> getRecentTransactions(SellStatus status) async {
    final uri = Uri(
      path: AppConstants.recentTransactionsUri,
      queryParameters: {"status": status.value},
    );
    Response response = await apiClient.getData(uri.toString());
    return response;
  }

  @override
  Future<Response> createSellPos(SellPosRequest request) async {
    Response response = await apiClient.postData(
      AppConstants.sellPosUri,
      request.toJson(),
    );
    return response;
  }

  @override
  Future<Response> getDefaultData() async {
    Response response = await apiClient.getData(
      AppConstants.sellPosCreateDataUri,
    );
    return response;
  }

  @override
  Future<Response> getProductRow({
    required int variationId,
    required int locationId,
  }) async {
    return await apiClient.getData(
      AppConstants.productRowUri(variationId, locationId),
    );
  }

  @override
  Future<Response> loadOrderForEdit(int transactionId) async {
    Response response = await apiClient.getData(
      AppConstants.editOrderUri(transactionId),
    );
    return response;
  }

  @override
  Future<Response> updateOrder(
    int transactionId,
    SellPosRequest request,
  ) async {
    Response response = await apiClient.putData(
      AppConstants.updateOrderUri(transactionId),
      request.toJson(),
    );
    return response;
  }
}
