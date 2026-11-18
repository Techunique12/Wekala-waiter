import 'package:wekala_waiter/core/localization/model/language_model.dart';
import 'package:wekala_waiter/util/images.dart';

class AppConstants {
  static const String appName = "app_name";
  static const String appVersion = "1.0.0";

  static const String currency = '£';

  static const String baseUrl = 'https://uat.tech-unique.com';

  static const String fontFamily = 'Roboto';
  static const String deviceName = 'waiter-app';

  // Auth APIs
  static const String loginUri = '/api/v1/login';
  static const String meUri = '/api/v1/me';
  static const String logoutUri = '/api/v1/logout';

  // Cash Register APIs
  static const String cashRegisterUri = '/api/v1/cash-registers';
  static const String checkRegisterUri = '$cashRegisterUri/create';
  static const String openRegisterUri = cashRegisterUri;
  static const String closeRegisterDataUri = '$cashRegisterUri/close-data';
  static const String closeRegisterUri = '$cashRegisterUri/close';

  // Table APIs
  static const String tableListUri = '/api/v1/tables';
  static const String tableStatusUri = '/api/v1/tables/status';
  static String changeTableUri(int transactionId) =>
      '/api/v1/tables/orders/$transactionId/move';
  static String reserveTableUri(int tableId) =>
      '/api/v1/tables/$tableId/reserve';
  static String cancelReservationUri(int bookingId) =>
      '/api/v1/reservations/$bookingId/cancel';
  static String checkInReservationUri(int bookingId) =>
      '/api/v1/reservations/$bookingId/check-in';
  static const String reservationsUri = '/api/v1/reservations/';
  static String reservationUri(int bookingId) => '$reservationsUri$bookingId';

  // Sell POS APIs
  static const String sellPosUri = '/api/v1/sell-pos';

  // Product APIs
  static const String sellPosCreateDataUri = '$sellPosUri/create-data';
  static const String productSuggestionUri = '$sellPosUri/product-suggestion';
  static String productRowUri(int variationId, int locationId) =>
      '$sellPosUri/product-row/$variationId/$locationId';

  // Service APIs
  static const String typesOfServiceUri = '/api/v1/types-of-service';

  // Order APIs
  static const String createOrderUri = sellPosUri;
  static const String recentTransactionsUri = '$sellPosUri/recent-transactions';
  static String editOrderUri(int id) => '$sellPosUri/$id/edit';
  static String updateOrderUri(int id) => '$sellPosUri/$id';

  // Customers APIs
  static const String searchCustomersUri = '/api/v1/contacts/search-customers';
  static String getCustomerDueUri(int contactId) =>
      '/api/v1/contacts/$contactId/due';

  /// Shared Key
  static const String token = 'waiter_token';
  static const String languageKey = 'waiter_language_code';
  static const String deviceIdKey = 'device_id';
  static const String userNameKey = 'user_name';
  static const String userIdKey = 'user_id';
  static const String passwordKey = 'user_password';
  static const String cashRegisterData = 'cash_register_data';

  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: Images.english,
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      imageUrl: Images.arabic,
      languageName: 'Arabic',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}
