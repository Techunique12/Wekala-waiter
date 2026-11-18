import 'package:get/get_connect/http/src/response/response.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/tables/domain/models/reserve_table_request.dart';
import 'package:wekala_waiter/features/tables/domain/repositories/tables_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class TablesRepository implements TablesRepositoryInterface {
  final ApiClient apiClient;

  TablesRepository({required this.apiClient});

  @override
  Future<Response<dynamic>> getTables(int locationId) async {
    Response response = await apiClient.getData(
      '${AppConstants.tableStatusUri}/?location_id=$locationId',
    );

    return response;
  }

  @override
  Future<Response> changeTable(int transactionId, int newTableId) async {
    Response response = await apiClient.postData(
      AppConstants.changeTableUri(transactionId),
      {"new_table_id": newTableId},
    );
    return response;
  }

  @override
  Future<Response> reserveTables(
    int tableId,
    ReserveTableRequest request,
  ) async {
    Response response = await apiClient.postData(
      AppConstants.reserveTableUri(tableId),
      request.toJson(),
    );
    return response;
  }

  @override
  Future<Response> cancelReservation(int bookingId) async {
    Response response = await apiClient.postData(
      AppConstants.cancelReservationUri(bookingId),
      {},
    );
    return response;
  }

  @override
  Future<Response> checkInReservation(int bookingId) async {
    Response response = await apiClient.postData(
      AppConstants.checkInReservationUri(bookingId),
      {},
    );
    return response;
  }

  @override
  Future<Response> getReservation(int bookingId) async {
    Response response = await apiClient.getData(
      AppConstants.reservationUri(bookingId),
    );
    return response;
  }

  @override
  Future<Response> updateReservation(
    int bookingId,
    ReserveTableRequest request,
  ) async {
    Response response = await apiClient.putData(
      AppConstants.reservationUri(bookingId),
      request.toJson(),
    );
    return response;
  }
}
