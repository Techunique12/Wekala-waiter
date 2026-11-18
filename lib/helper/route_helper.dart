import 'package:get/get.dart';
import 'package:wekala_waiter/features/auth/screens/auth_check_screen.dart';
import 'package:wekala_waiter/features/auth/screens/sign_in_screen.dart';
import 'package:wekala_waiter/features/customer/bindings/customer_binding.dart';
import 'package:wekala_waiter/features/customer/screens/customer_search_screen.dart';
import 'package:wekala_waiter/features/dashboard/screens/dashboard_screen.dart';
import 'package:wekala_waiter/features/products/bindings/products_binding.dart';
import 'package:wekala_waiter/features/products/screens/products_screen.dart';
import 'package:wekala_waiter/features/register/screens/register_check_screen.dart';
import 'package:wekala_waiter/features/register/screens/register_close_screen.dart';
import 'package:wekala_waiter/features/register/screens/register_open_screen.dart';
import 'package:wekala_waiter/features/sell_pos/bindings/pos_binding.dart';
import 'package:wekala_waiter/features/sell_pos/bindings/recent_transactions_binding.dart';
import 'package:wekala_waiter/features/sell_pos/screens/order_screen.dart';
import 'package:wekala_waiter/features/sell_pos/screens/recent_transactions_screen.dart';
import 'package:wekala_waiter/features/service/bindings/service_binding.dart';
import 'package:wekala_waiter/features/tables/bindings/tables_binding.dart';
import 'package:wekala_waiter/features/tables/screens/reserved_table_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String signIn = '/sign-in';
  static const String authCheck = '/auth-check';
  static const String registerCheck = '/register-check';
  static const String registerOpen = '/register-open';
  static const String registerClose = '/register-close';
  static const String recentTransactions = '/recent-transactions';
  static const String order = '/order';
  static const String products = '/products';
  static const String reservedTable = '/reserved-table';
  static const String customerSearch = '/customer-search';

  static List<GetPage> routes = [
    // Dashboard
    GetPage(
      name: initial,
      page: () => const DashboardScreen(),
      bindings: [ServiceBinding(), RecentTransactionsBinding()],
    ),

    // Recent Transactions
    GetPage(
      name: recentTransactions,
      page: () => const RecentTransactionsScreen(),
    ),

    // Order
    GetPage(
      name: order,
      page: () => const OrderScreen(),
      bindings: [PosBinding(), TablesBinding()],
    ),

    // Products
    GetPage(
      name: products,
      page: () => const ProductsScreen(),
      binding: ProductsBinding(),
    ),

    // Tables
    GetPage(name: reservedTable, page: () => const ReservedTableScreen()),

    // Customer
    GetPage(
      name: customerSearch,
      page: () => const CustomerSearchScreen(),
      binding: CustomerBinding(),
    ),

    // Register
    GetPage(name: registerCheck, page: () => const RegisterCheckScreen()),
    GetPage(name: registerOpen, page: () => const RegisterOpenScreen()),
    GetPage(name: registerClose, page: () => const RegisterCloseScreen()),

    // Auth
    GetPage(name: signIn, page: () => const SigninScreen()),
    GetPage(name: authCheck, page: () => const AuthCheckScreen()),
  ];
}
