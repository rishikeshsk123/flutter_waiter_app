part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    required List<Product> products, // A list of products
    required List<Product> filteredProducts, // holds the search results
    @Default(1) int quantity,
  }) = _ProductState;

  factory ProductState.initial() => ProductState(
        products: [], // Initial empty list of products
        filteredProducts: [],
      );
}

