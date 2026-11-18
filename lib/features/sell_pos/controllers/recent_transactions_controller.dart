import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/recent_transactions_model.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository_interface.dart';

class RecentTransactionsController extends GetxController {
  final PosRepositoryInterface posRepository;

  RecentTransactionsController({required this.posRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SellStatus _status = SellStatus.completed;
  SellStatus get status => _status;

  RecentTransactionsResponse? _recentTransactions;

  List<RecentTransactionModel> get transactions =>
      _recentTransactions?.data ?? [];
  @override
  void onInit() {
    super.onInit();
    getRecentTransactions();
  }

  Future<void> getRecentTransactions({SellStatus? status}) async {
    if (status != null) {
      _status = status;
    }

    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await posRepository.getRecentTransactions(
        _status,
      );

      if (response.statusCode == 200) {
        _recentTransactions = RecentTransactionsResponse.fromJson(
          response.body,
        );

        debugPrint('Transactions loaded: ${transactions.length}');
      } else {
        debugPrint('Error getting transactions: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error getting recent transactions: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> changeStatus(SellStatus status) async {
    if (_status == status) return;

    _status = status;

    await getRecentTransactions();
  }

  Future<void> refreshTransactions() async {
    await getRecentTransactions();
  }
}
