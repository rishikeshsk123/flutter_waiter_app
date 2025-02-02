import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/domain/model/product/product.dart';
import 'package:restaurant_app/domain/products/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductState.initial()) {
    on<_FetchProducts>(_mapFetchProductsToState);
    on<_SearchProducts>(_mapSearchProductsToState);
    on<_FilterByCategory>(_mapFilterByCategoryToState);
    on<_UpdatePriceForASP>(_mapUpdatePriceToState);
  }

  Future<void> _mapFetchProductsToState(
      _FetchProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Make a GET request using Dio to fetch the products from an API
      final products = await productRepository.fetchProducts();
      final categories = await productRepository.fetchCategories();
      // print(categories);
      emit(state.copyWith(
        products: products,
        categories: categories,
        isLoading: false,
      ));
    } catch (e) {
      // handle errror if something goes wrong
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      // print('Error loading products: $e');
    }
  }

  void _mapSearchProductsToState(
      _SearchProducts event, Emitter<ProductState> emit) async {
    final query = event.query.toLowerCase();
    final filtered = await state.products
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();

    emit(state.copyWith(filteredProducts: filtered));
  }

  void _mapFilterByCategoryToState(
      _FilterByCategory event, Emitter<ProductState> emit) async {
    if (event.category == 'All') {
      emit(state.copyWith(filteredProducts: state.products));
    } else {
      final filtered = await state.products
          .where((product) => product.category == event.category)
          .toList();
      emit(state.copyWith(filteredProducts: filtered));
    }
  }

  Future<void> _mapUpdatePriceToState(
      _UpdatePriceForASP event, Emitter<ProductState> emit) async {
    final updatedProducts = await state.products.map((product) {
      if (product.id == event.id) {
        return product.copyWith(price: event.price);
      }
      return product;
    }).toList();
    emit(state.copyWith(products: updatedProducts));
  }
}
