import 'package:get/get.dart';

abstract class CustomerRepositoryInterface {
  Future<Response> searchCustomers(String query);
  Future<Response> getCustomerDue(int contactId);
}
