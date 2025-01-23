import 'package:bloc/bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/api/product.dart';
import 'package:restaurant_app/domain/model/product/product.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState.initial()) {
    on<_FetchProducts>(_mapFetchProductsToState);
    on<_SearchProducts>(_mapSearchProductsToState);
    on<_FilterByCategory>(_mapFilterByCategoryToState);
    on<_UpdatePriceForASP>(_mapUpdatePriceToState);
  }

  Future<void> _mapFetchProductsToState(
      _FetchProducts event, Emitter<ProductState> emit) async {
    try {
      // Make a GET request using Dio to fetch the products from an API
      final List<Product> products = await productJson
          .map((jsonProduct) => Product.fromJson(jsonProduct))
          .toList();

      emit(state.copyWith(products: products, filteredProducts: products));
    } catch (e) {
      // handle errror if something goes wrong
      emit(state.copyWith(products: [], filteredProducts: []));
      // print('Error loading products: $e');
    }
  }

  void _mapSearchProductsToState(
      _SearchProducts event, Emitter<ProductState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.products
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();

    emit(state.copyWith(filteredProducts: filtered));
  }

  void _mapFilterByCategoryToState(
      _FilterByCategory event, Emitter<ProductState> emit) {
    if (event.category == 'All') {
      emit(state.copyWith(filteredProducts: state.products));
    } else {
      final filtered = state.products
          .where((product) => product.category == event.category)
          .toList();
      emit(state.copyWith(filteredProducts: filtered));
    }
  }

  Future<void> _mapUpdatePriceToState(
      _UpdatePriceForASP event, Emitter<ProductState> emit) async {
    final updatedProducts = state.products.map((product) {
      if (product.name == event.name) {
       
        return product.copyWith(price: event.price);
      }
      return product;
    }).toList();
    emit(state.copyWith(products: updatedProducts));
  }
}
