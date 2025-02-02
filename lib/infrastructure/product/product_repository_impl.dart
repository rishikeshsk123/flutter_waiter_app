// import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/api/product.dart';
import 'package:restaurant_app/domain/model/product/product.dart';
import 'package:restaurant_app/domain/products/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> fetchProducts() async {
    try {
      // Make a GET request using Dio to fetch the products from an API

      // final response = await _dio.get('https://api.example.com/products');

      final response = await productJson;

      return response.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final response = await productJson.map((json) => Product.fromJson(json)).toList();
      final data = response.map((e) => e.category).toSet();
      final resData = ['All', ...data];
      // final response = await Dio(BaseOptions())
      //     .get('https://dummyjson.com/products/category-list');
      // return List<String>.from(response.data);
      return resData;
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
