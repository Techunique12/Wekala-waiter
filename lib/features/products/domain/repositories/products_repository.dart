import 'package:get/get.dart';
import 'package:wekala_waiter/api/api_client.dart';
import 'package:wekala_waiter/features/products/domain/repositories/products_repository_interface.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class ProductsRepository implements ProductsRepositoryInterface {
  final ApiClient apiClient;

  ProductsRepository({required this.apiClient});

  @override
  Future<Response> getProducts(
    int locationId, {
    String? term,
    int page = 1,
  }) async {
    final query = <String, String>{
      'location_id': locationId.toString(),
      'page': page.toString(),
      if (term?.isNotEmpty ?? false) 'term': term!,
    };

    final uri = Uri(
      path: AppConstants.productSuggestionUri,
      queryParameters: query,
    );

    return await apiClient.getData(uri.toString());
  }
}
