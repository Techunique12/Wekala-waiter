import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/features/products/domain/models/products_model.dart';
import 'package:wekala_waiter/features/products/domain/repositories/products_repository_interface.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';

class ProductsController extends GetxController {
  final ProductsRepositoryInterface productsRepository;

  ProductsController({required this.productsRepository});

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _lastPage = 1;
  int get lastPage => _lastPage;

  bool get hasMore => _currentPage < _lastPage;

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<void> getProducts({bool loadMore = false}) async {
    // منع طلبات pagination المتكررة
    if (loadMore && _isLoadingMore) {
      return;
    }

    // منع تحميل الصفحة الأولى أكثر من مرة
    if (!loadMore && _isLoading) {
      return;
    }

    final registerController = Get.find<RegisterController>();

    final locationId = registerController.currentRegister?.locationId;

    if (locationId == null) {
      debugPrint('Location ID not found');
      return;
    }

    final int page = loadMore ? _currentPage + 1 : 1;

    // مفيش صفحات تانية
    if (loadMore && page > _lastPage) {
      return;
    }

    if (loadMore) {
      _isLoadingMore = true;
    } else {
      _isLoading = true;

      // Reset pagination
      _currentPage = 1;
      _lastPage = 1;

      // Reset products
      _products = [];
    }

    update();

    try {
      final response = await productsRepository.getProducts(
        locationId,
        term: _searchTerm.isEmpty ? null : _searchTerm,
        page: page,
      );

      if (response.statusCode != 200) {
        if (!loadMore) {
          _products = [];
        }

        return;
      }

      final model = ProductsModel.fromJson(response.body);

      final newProducts = model.data?.products ?? [];

      final pagination = model.data?.pagination;

      _currentPage = pagination?.currentPage ?? page;
      _lastPage = pagination?.lastPage ?? 1;

      if (loadMore) {
        _products.addAll(newProducts);
      } else {
        _products = newProducts;
      }
    } catch (e) {
      debugPrint('Get Products Error: $e');

      if (!loadMore) {
        _products = [];
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;

      update();
    }
  }

  void searchProducts(String value) {
    _searchTerm = value.trim();

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      getProducts();
    });
  }

  void clearSearch() {
    _searchTerm = '';

    _searchDebounce?.cancel();

    getProducts();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
