import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/features/customer/domain/models/customer_model.dart';
import 'package:wekala_waiter/features/customer/domain/repositories/customer_repository_interface.dart';

class CustomerController extends GetxController {
  final CustomerRepositoryInterface customerRepository;

  CustomerController({required this.customerRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();

    loadCustomers();
  }

  /// Load all customers initially
  Future<void> loadCustomers() async {
    await searchCustomers(query: '');
  }

  /// Search customers
  void onSearchChanged(String value) {
    _searchTimer?.cancel();

    final query = value.trim();

    // Empty search = show all customers
    if (query.isEmpty) {
      loadCustomers();
      return;
    }

    _searchTimer = Timer(
      const Duration(milliseconds: 400),
      () => searchCustomers(query: query),
    );
  }

  Future<void> searchCustomers({required String query}) async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final Response response = await customerRepository.searchCustomers(
        query.trim(),
      );

      if (response.statusCode == 200) {
        final data = response.body['data'] as List? ?? [];

        _customers = data
            .map((item) => Customer.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        _customers = [];
      }
    } catch (e) {
      debugPrint('Error searching customers: $e');
      _customers = [];
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<double> getCustomerDue(int contactId) async {
    try {
      final Response response = await customerRepository.getCustomerDue(
        contactId,
      );

      if (response.statusCode == 200) {
        return double.tryParse(response.body['data']['due'].toString()) ?? 0.0;
      }
    } catch (e) {
      debugPrint('Error getting customer due: $e');
    }

    return 0.0;
  }

  void clearSearch() {
    _searchTimer?.cancel();
    loadCustomers();
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }
}
