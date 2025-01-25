part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.fetchProducts() = _FetchProducts;
  const factory ProductEvent.searchProducts(String query) = _SearchProducts;
  const factory ProductEvent.filterByCategory(String category) = _FilterByCategory;
  const factory ProductEvent.updatePriceForASP(String id, double price) = _UpdatePriceForASP;
}
