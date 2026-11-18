import 'package:get/get.dart';
import 'package:wekala_waiter/features/tables/domain/models/reserve_table_request.dart';

abstract class TablesRepositoryInterface {
  Future<Response> getTables(int locationId);
  Future<Response> changeTable(int transactionId, int newTableId);
  Future<Response> reserveTables(int tableId, ReserveTableRequest request);
  Future<Response> cancelReservation(int bookingId);
  Future<Response> updateReservation(
    int bookingId,
    ReserveTableRequest request,
  );
  Future<Response> checkInReservation(int bookingId);
  Future<Response> getReservation(int bookingId);
}
