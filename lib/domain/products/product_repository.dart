import 'package:restaurant_app/domain/model/product/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<List<String>> fetchCategories();
}