import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/core/enums/discount_type.dart';
import 'package:wekala_waiter/core/enums/pos_order_action.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/features/customer/controllers/customer_controller.dart';
import 'package:wekala_waiter/features/customer/domain/models/customer_model.dart';
import 'package:wekala_waiter/features/customer/domain/repositories/customer_repository.dart';
import 'package:wekala_waiter/features/products/domain/models/products_model.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/order_tax_model.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/payment_account_model.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/sell_details_model.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/sell_pos_request.dart';
import 'package:wekala_waiter/features/sell_pos/domain/repositories/pos_repository_interface.dart';
import 'package:wekala_waiter/features/service/domain/models/service_model.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/domain/models/table_model.dart';

class PosController extends GetxController {
  final PosRepositoryInterface posRepository;

  PosController({required this.posRepository});

  late final ServiceModel service;

  // Loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Table
  TableModel? _selectedTable;

  TableModel? get selectedTable => _selectedTable;

  // Customer
  Customer? _selectedCustomer;
  Customer? _defaultCustomer;

  Customer? get customer => _selectedCustomer ?? _defaultCustomer;

  bool get isSelectedCustomer => _selectedCustomer != null;

  double _selectedCustomerDue = 0.0;

  double get selectedCustomerDue => _selectedCustomerDue;

  // Payments
  List<PaymentAccountModel> _defaultPayments = [];

  List<PaymentAccountModel> get defaultPayments => _defaultPayments;

  String? _selectedPaymentMethod;

  String get selectedPaymentMethod =>
      _selectedPaymentMethod ??
      (_defaultPayments.isNotEmpty ? _defaultPayments.first.method : 'cash');

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    update();
  }

  // Cart
  final List<CartItem> _selectedProducts = [];

  List<CartItem> get selectedProducts => _selectedProducts;

  DiscountType _discountType = DiscountType.percent;

  DiscountType get discountType => _discountType;

  double _discountValue = 0.0;

  double get discountValue => _discountValue;

  double get subtotal {
    return _selectedProducts.fold(0.0, (sum, item) => sum + item.total);
  }

  // Order Tax
  TaxRateModel? _selectedOrderTax;

  TaxRateModel? get selectedOrderTax => _selectedOrderTax;

  List<TaxRateModel> _orderTaxes = [];

  List<TaxRateModel> get orderTaxes => _orderTaxes;

  void selectOrderTax(TaxRateModel? tax) {
    _selectedOrderTax = tax;
    update();
  }

  double get shipping => 0.0;

  double get orderTax {
    final TaxRateModel? tax = _selectedOrderTax;

    if (tax == null || tax.amount <= 0) {
      return 0.0;
    }

    final double taxableAmount = subtotal - discount;

    if (taxableAmount <= 0) {
      return 0.0;
    }

    return taxableAmount * tax.amount / 100;
  }

  double get servicePrice {
    final double charge = service.packingCharge;
    final String type = service.packingChargeType;

    if (type == 'percent') {
      return subtotal * charge / 100;
    }

    return charge;
  }

  double get discount {
    if (_discountType == DiscountType.percent) {
      return subtotal * _discountValue / 100;
    }

    return _discountValue;
  }

  double get totalPayable {
    return subtotal -
        discount +
        // productTax +
        orderTax +
        shipping +
        servicePrice;
  }

  @override
  void onInit() {
    super.onInit();

    service = Get.arguments as ServiceModel;

    getDefaultData();
  }

  // Discount
  void editDiscount({required DiscountType type, required double value}) {
    _discountType = type;
    _discountValue = value;

    update();
  }

  // Table
  void selectTable(TableModel table) {
    _selectedTable = table;

    update();
  }

  void clearSelectedTable() {
    _selectedTable = null;

    update();
  }

  // Customer
  Future<void> selectCustomer(Customer customer) async {
    _selectedCustomer = customer;

    final customerController = Get.find<CustomerController>();

    _selectedCustomerDue = await customerController.getCustomerDue(customer.id);

    update();
  }

  void clearSelectedCustomer() {
    _selectedCustomer = null;
    _selectedCustomerDue = 0.0;

    update();
  }

  // Products
  Future<void> toggleProduct(Product product) async {
    final int index = _selectedProducts.indexWhere(
      (item) => item.product.variationId == product.variationId,
    );

    if (index != -1) {
      _selectedProducts.removeAt(index);

      update();

      return;
    }

    _selectedProducts.add(CartItem(product: product, quantity: 1));

    update();
  }

  bool isProductSelected(Product product) {
    return _selectedProducts.any(
      (item) => item.product.variationId == product.variationId,
    );
  }

  int getProductQuantity(Product product) {
    final int index = _selectedProducts.indexWhere(
      (item) => item.product.variationId == product.variationId,
    );

    if (index == -1) {
      return 0;
    }

    return _selectedProducts[index].quantity;
  }

  int getProductOldQuantity(Product product) {
    final int index = _selectedProducts.indexWhere(
      (item) => item.product.variationId == product.variationId,
    );

    if (index == -1) {
      return 0;
    }

    return _selectedProducts[index].oldQuantity;
  }

  void increaseQuantity(Product product) {
    final int index = _selectedProducts.indexWhere(
      (item) => item.product.variationId == product.variationId,
    );

    if (index == -1) {
      return;
    }

    final CartItem item = _selectedProducts[index];

    if (item.quantity < product.quantityAvailable) {
      item.quantity++;

      update();
    }
  }

  void decreaseQuantity(Product product) {
    final int index = _selectedProducts.indexWhere(
      (item) => item.product.variationId == product.variationId,
    );

    if (index == -1) {
      return;
    }

    final CartItem item = _selectedProducts[index];

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _selectedProducts.removeAt(index);

      // _productTaxes.remove(product.variationId);
    }

    update();
  }

  void clearSelectedProducts() {
    _selectedProducts.clear();

    // _productTaxes.clear();

    update();
  }

  void clearCurrentOrder() {
    _selectedProducts.clear();
    _selectedCustomer = null;
    _selectedCustomerDue = 0.0;
    _selectedTable = null;
    _discountType = DiscountType.percent;
    _discountValue = 0.0;
    _selectedOrderTax = null;
    _selectedPaymentMethod = null;
    _orderNote = null;
    _editingTransactionId = null;
    update();
  }

  bool get hasOrderData {
    return _selectedProducts.isNotEmpty ||
        _selectedCustomer != null ||
        _selectedTable != null ||
        _orderNote != null ||
        _discountValue > 0.0;
  }

  Future<bool> createSellPos({
    SellStatus status = SellStatus.completed,
    required PosOrderAction action,
    required String message,
  }) async {
    if (_isLoading) return false;

    _isLoading = true;
    update();

    try {
      final RegisterController registerController =
          Get.find<RegisterController>();

      final registerData = registerController.currentRegister;

      final int? locationId = registerData?.locationId;

      if (locationId == null) {
        debugPrint('Location ID not found');
        return false;
      }

      final int? contactId = customer?.id;

      if (contactId == null) {
        debugPrint('Contact ID not found');
        return false;
      }

      final String? taxRateId = _selectedOrderTax?.id.toString();

      final List<SellPosProductRequest> products = _selectedProducts.map((
        item,
      ) {
        final Product product = item.product;

        return SellPosProductRequest(
          productId: product.productId,
          variationId: product.variationId,
          quantity: item.quantity,
          unitPrice: product.sellingPrice,
          unitPriceIncTax: product.sellPriceIncTax,
          itemTax: product.itemTax,
          taxId: product.taxId,
          enableStock: product.enableStock,
          productType: product.type,
        );
      }).toList();

      final SellPosRequest request = SellPosRequest(
        locationId: locationId,
        contactId: contactId,
        status: status,
        discountType: _discountType.name,
        discountAmount: discount,
        taxRateId: taxRateId,
        finalTotal: totalPayable,
        typesOfServiceId: service.id,
        products: products,
        note: _orderNote,
        resTableId: _selectedTable?.id,
        orderAction: action,
        payment: [
          SellPosPaymentRequest(
            amount: totalPayable,
            method: selectedPaymentMethod,
          ),
        ],
      );

      final Response response = await posRepository.createSellPos(request);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(message, isError: false);

        clearCurrentOrder();

        return true;
      }

      debugPrint(
        'Create Sell POS failed: '
        '${response.statusCode} '
        '${response.body}',
      );

      return false;
    } catch (e, stackTrace) {
      debugPrint('Error creating POS: $e');
      debugPrintStack(stackTrace: stackTrace);

      return false;
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> getDefaultData() async {
    if (_isLoading) return;

    _isLoading = true;
    update();

    try {
      final RegisterController registerController =
          Get.find<RegisterController>();

      final registerData = registerController.currentRegister;

      final int? locationId = registerData?.locationId;

      if (locationId == null) {
        return;
      }

      final Response response = await posRepository.getDefaultData();

      if (response.statusCode != 200) {
        return;
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );

      final taxes = Map<String, dynamic>.from(data['taxes'] ?? {});

      final taxRates = Map<String, dynamic>.from(taxes['tax_rates'] ?? {});

      final attributes = Map<String, dynamic>.from(taxes['attributes'] ?? {});
      debugPrint('taxRates.toString()${data.toString()}');

      _orderTaxes = taxRates.entries.map((entry) {
        final String id = entry.key;
        final String name = entry.value.toString();

        final attribute = attributes[id];

        double amount = 0.0;

        if (attribute is Map<String, dynamic>) {
          amount =
              double.tryParse(attribute['data-rate']?.toString() ?? '') ?? 0.0;
        }

        return TaxRateModel.fromJson(id: id, name: name, amount: amount);
      }).toList();

      // Default Customer
      if (data['walk_in_customer'] != null) {
        _defaultCustomer = Customer.fromJson(data['walk_in_customer']);
      }

      // Default Payment Accounts
      final Map<String, dynamic>? locationAttributes =
          data['bl_attributes'] != null
          ? Map<String, dynamic>.from(data['bl_attributes'])[locationId
                        .toString()] !=
                    null
                ? Map<String, dynamic>.from(
                    Map<String, dynamic>.from(data['bl_attributes'])[locationId
                        .toString()],
                  )
                : null
          : null;

      if (locationAttributes == null) {
        return;
      }

      final String? paymentAccountsJson =
          locationAttributes['data-default_payment_accounts'];

      if (paymentAccountsJson == null || paymentAccountsJson.isEmpty) {
        return;
      }

      final Map<String, dynamic> paymentAccounts = jsonDecode(
        paymentAccountsJson,
      );

      debugPrint(
        'Default Payment Accounts: '
        '$paymentAccounts',
      );

      _defaultPayments = paymentAccounts.entries
          .map(
            (entry) => PaymentAccountModel.fromJson(
              entry.key,
              Map<String, dynamic>.from(entry.value),
            ),
          )
          .toList();

      debugPrint(
        'Default Payments Count: '
        '${_defaultPayments.length}',
      );
    } catch (e) {
      debugPrint('Error getting default payments: $e');
    } finally {
      _isLoading = false;

      update();
    }
  }

  // Notes
  String? _orderNote;

  String? get orderNote => _orderNote;

  void setOrderNote(String value) {
    _orderNote = value;
    update();
  }

  void clearOrderNote() {
    _orderNote = null;
    update();
  }

  Future<void> loadOrderForEdit() async {
    if (_isLoading) return;
    _isLoading = true;
    update();

    try {
      final int? transactionId = _editingTransactionId;

      if (transactionId == null) {
        debugPrint('Transaction ID not found');
        return;
      }

      final Response response = await posRepository.loadOrderForEdit(
        _editingTransactionId!,
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Load order for edit failed: '
          '${response.statusCode} ${response.body}',
        );
        return;
      }

      final Map<String, dynamic> body = Map<String, dynamic>.from(
        response.body,
      );

      final sellDetailsModel = SellDetailsModel.fromJson(body);

      final data = sellDetailsModel.data;

      final transaction = data?.transaction;
      final sellDetails = data?.sellDetails ?? [];
      final paymentLines = data?.paymentLines ?? [];

      // Customer
      final int? contactId = int.tryParse(
        transaction?.contactId?.toString() ?? '',
      );

      if (contactId != null) {
        // Find customer from CustomerController if needed.
        final CustomerController customerController = CustomerController(
          customerRepository: CustomerRepository(
            apiClient: Get.find<ApiClient>(),
          ),
        );

        await customerController.loadCustomers();

        final int index = customerController.customers.indexWhere(
          (element) => element.id == contactId,
        );

        if (index != -1) {
          final Customer customer = customerController.customers[index];

          _selectedCustomer = customer;

          _selectedCustomerDue = await customerController.getCustomerDue(
            customer.id,
          );
        } else {
          debugPrint('Customer with ID $contactId not found');
        }
      }

      // Discount
      final String discountType =
          transaction?.discountType?.toString() ?? 'fixed';

      _discountType = discountType == 'percent'
          ? DiscountType.percent
          : DiscountType.fixed;

      _discountValue =
          double.tryParse(transaction?.discountAmount.toString() ?? '') ?? 0.0;

      // Order Tax
      _selectedOrderTax = null;

      final int? taxId = int.tryParse(transaction?.taxId?.toString() ?? '');

      if (taxId != null) {
        final int index = _orderTaxes.indexWhere((tax) => tax.id == taxId);

        if (index != -1) {
          _selectedOrderTax = _orderTaxes[index];
        }
      }

      // Payment
      _selectedPaymentMethod = null;

      if (paymentLines.isNotEmpty) {
        _selectedPaymentMethod = paymentLines.first.method.toString();
      }

      // Note
      _orderNote = transaction?.additionalNotes?.toString();

      // Products
      _selectedProducts.clear();

      for (final Product product in sellDetails) {
        debugPrint(product.quantityOrdered.toString());
        // Quantity
        final int quantity = product.quantityOrdered > 0
            ? product.quantityOrdered
            : 1;

        // Product Tax
        final int? itemTaxId = product.taxId;

        final double unitPriceIncTax = product.sellPriceIncTax;

        final double taxAmount = product.itemTax;

        // Add Product To Cart
        _selectedProducts.add(
          CartItem(
            product: product,
            quantity: quantity,
            taxId: itemTaxId,
            itemTax: taxAmount,
            oldQuantity: quantity,
            unitPriceIncTax: unitPriceIncTax,
          ),
        );
      }

      // Table
      _selectedTable = null;

      final int? tableId = int.tryParse(
        transaction?.resTableId?.toString() ?? '',
      );

      if (tableId != null) {
        try {
          final TablesController tablesController =
              Get.find<TablesController>();

          final int tableIndex = tablesController.tables.indexWhere(
            (table) => table.id == tableId,
          );

          if (tableIndex != -1) {
            _selectedTable = tablesController.tables[tableIndex];
          } else {
            debugPrint('Table not found locally: $tableId');
          }
        } catch (e) {
          debugPrint('Error finding table: $e');
        }
      }

      // Debug
      debugPrint('========== EDIT ORDER ==========');

      debugPrint('Order loaded successfully');

      debugPrint('Transaction ID: ${transaction?.id}');

      debugPrint('Products: ${_selectedProducts.length}');

      debugPrint('Customer ID: $contactId');
      debugPrint('Customer ID: ${_selectedCustomer?.contactId}');

      debugPrint('Table ID: $tableId');

      debugPrint('Discount: $_discountType / $_discountValue');

      debugPrint('Payment: $_selectedPaymentMethod');

      debugPrint('Note: $_orderNote');

      for (final cartItem in _selectedProducts) {
        debugPrint(
          'Product: ${cartItem.product.name} | '
          'Qty: ${cartItem.quantity} | '
          'Price: ${cartItem.product.sellingPrice} | '
          'Price Inc Tax: ${cartItem.unitPriceIncTax} | '
          'Tax: ${cartItem.itemTax}',
        );
      }

      debugPrint('================================');

      update();
    } catch (e, stackTrace) {
      debugPrint('Error loading order for edit: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<bool> updateOrder({
    SellStatus status = SellStatus.completed,
    required PosOrderAction action,
    required String message,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    update();

    try {
      final RegisterController registerController =
          Get.find<RegisterController>();

      final registerData = registerController.currentRegister;

      final int? locationId = registerData?.locationId;

      if (locationId == null) {
        debugPrint('Location ID not found');
        return false;
      }

      final int? contactId = customer?.id;

      if (contactId == null) {
        debugPrint('Contact ID not found');
        return false;
      }

      final String? taxRateId = _selectedOrderTax?.id.toString();

      final List<SellPosProductRequest> products = _selectedProducts.map((
        item,
      ) {
        final Product product = item.product;

        return SellPosProductRequest(
          productId: product.productId,
          variationId: product.variationId,
          quantity: item.quantity,
          unitPrice: product.sellingPrice,
          unitPriceIncTax: item.unitPriceIncTax,
          itemTax: item.itemTax,
          taxId: item.taxId,
          enableStock: product.enableStock,
          productType: product.type,
        );
      }).toList();

      final SellPosRequest request = SellPosRequest(
        locationId: locationId,
        contactId: contactId,
        status: status,
        discountType: _discountType.name,
        discountAmount: discount,
        taxRateId: taxRateId,
        finalTotal: totalPayable,
        typesOfServiceId: service.id,
        products: products,
        note: _orderNote,
        resTableId: _selectedTable?.id,
        orderAction: action,
        payment: [
          SellPosPaymentRequest(
            amount: totalPayable,
            method: selectedPaymentMethod,
          ),
        ],
      );

      debugPrint('========== UPDATE ORDER ==========');
      debugPrint('Transaction ID: $_editingTransactionId');
      debugPrint('Location ID: $locationId');
      debugPrint('Contact ID: $contactId');
      debugPrint('Discount: $_discountType / $_discountValue');
      debugPrint('Order Tax: ${_selectedOrderTax?.id}');
      debugPrint('Payment: $selectedPaymentMethod');
      debugPrint('Total: $totalPayable');
      debugPrint('Products: ${products.length}');
      for (final item in _selectedProducts) {
        debugPrint(
          'CART => '
          '${item.product.name} | '
          'old=${item.oldQuantity} | '
          'new=${item.quantity}',
        );
      }
      for (final product in products) {
        debugPrint(
          'Product: '
          'productId=${product.productId}, '
          'variationId=${product.variationId}, '
          'qty=${product.quantity}, '
          'unitPrice=${product.unitPrice}, '
          'unitPriceIncTax=${product.unitPriceIncTax}, '
          'itemTax=${product.itemTax}, '
          'taxId=${product.taxId}',
        );
      }
      final int? transactionId = _editingTransactionId;
      if (transactionId == null) {
        debugPrint('Transaction ID not found');
        return false;
      }
      debugPrint('UPDATE REQUEST => ${jsonEncode(request.toJson())}');
      final Response response = await posRepository.updateOrder(
        transactionId,
        request,
      );

      debugPrint(
        'Update Order Response: '
        '${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(message, isError: false);

        clearCurrentOrder();

        return true;
      }

      debugPrint(
        'Update Order failed: '
        '${response.statusCode} ${response.body}',
      );

      return false;
    } catch (e) {
      debugPrint('Error updating order: $e');

      return false;
    } finally {
      _isLoading = false;
      update();
    }
  }

  int? _editingTransactionId;

  int? get editingTransactionId => _editingTransactionId;

  bool get isEditing => _editingTransactionId != null;

  void setEditingTransactionId(int transactionId) {
    _editingTransactionId = transactionId;
    update();
  }

  Future<bool> saveOrder({
    required PosOrderAction action,
    required String message,
  }) async {
    final bool isDraft = action == PosOrderAction.sendToKitchen;

    final SellStatus status = isDraft ? SellStatus.draft : SellStatus.completed;

    if (isEditing) {
      return await updateOrder(
        status: status,
        action: action,
        message: message,
      );
    }

    return await createSellPos(
      status: status,
      action: action,
      message: message,
    );
  }
}
