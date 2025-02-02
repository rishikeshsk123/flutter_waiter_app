import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/domain/model/cart/cart_item.dart';
import 'package:restaurant_app/domain/model/product/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final String userToken;
  CartBloc({required this.userToken}) : super(CartState.initial()) {
    on<_AddItem>(_mapAddItemToState);
    on<_RemoveItem>(_mapRemoveItemToState);
    on<_UpdateQuantity>(_mapUpdateQuantityToState);
    on<_UpdateOrderType>(_mapUpdateOrderType);
    on<_ClearCart>(_mapClearCartToState);
  }
  

  void _mapAddItemToState(_AddItem event, Emitter<CartState> emit) async {
    final existingItemIndex =
        state.items.indexWhere((item) => item.productId == event.product.id);

    if (existingItemIndex >= 0) {
      // If item already exists in cart, increase quantity
      final updatedItems = List<CartItem>.from(state.items);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      emit(state.copyWith(items: updatedItems));
    } else {
      // Add new item to the cart
      final newItem = CartItem(
        productId: event.product.id,
        name: event.product.name,
        quantity: 1,
        price: event.product.asp
            ? event.product.defaultPrice
            : event.product.price,
        asp: event.product.asp,
        defaultPrice: event.product.defaultPrice,
      );

      emit(state.copyWith(
          items: [...state.items, newItem],
          totalAmount: _calculateTotal([...state.items, newItem])));
    }
  }

  void _mapRemoveItemToState(_RemoveItem event, Emitter<CartState> emit) {
    // final existingItem = state.items.firstWhere(
    //   (item) => item.productId == event.product.id,
    //   // orElse: () {} ,
    // );

    // if (existingItem == null) {
    //   return;
    // }
    // Remove item if quantity is 1
    final updatedItems =
        state.items.where((item) => item.productId != event.productId).toList();

    emit(state.copyWith(
        items: updatedItems, totalAmount: _calculateTotal(updatedItems)));
    // }
  }

  void _mapUpdateQuantityToState(
      _UpdateQuantity event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
     
      if (item.productId == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(
        items: updatedItems, totalAmount: _calculateTotal(updatedItems)));
  }

  void _mapClearCartToState(_ClearCart event, Emitter<CartState> emit) {
    emit(state.copyWith(items: [], totalAmount: 0.0, serviceCharge: 0.0));
  }

  void _mapUpdateOrderType(_UpdateOrderType event, Emitter<CartState> emit) async{
    final serviceCharge =
        await _calculateServiceCharge(event.orderType, state.totalAmount);
    emit(state.copyWith(
        orderType: event.orderType, serviceCharge: serviceCharge));
  }

  Future<double> _calculateServiceCharge(String orderType, double totalAmount) async{
    switch (orderType) {
      case "Dine In":
        return totalAmount * 0;
      case "Takeaway":
        return totalAmount * 0.1;
      case "Delivery":
        return totalAmount * 0.15;
      case "Rooms":
        return totalAmount * 0.12;
      default:
        return 0;
    }
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(
        0.0, (total, item) => total + (item.price ) * item.quantity);
  }
}
