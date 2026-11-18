import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/sell_pos_request.dart';

abstract class PosRepositoryInterface {
  Future<Response> getRecentTransactions(SellStatus status);
  Future<Response> createSellPos(SellPosRequest request);
  Future<Response> getDefaultData();
  Future<Response> getProductRow({
    required int variationId,
    required int locationId,
  });
  Future<Response> loadOrderForEdit(int transactionId);
  Future<Response> updateOrder(int transactionId, SellPosRequest request);
}
