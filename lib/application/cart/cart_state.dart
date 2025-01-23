part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    required List<CartItem> items,
    required String orderType,
    required double serviceCharge,
    required double totalAmount,
  }) = _CartState;

  factory CartState.initial() => const CartState(
        items: [],
        orderType: "Dine In",
        serviceCharge: 0.0,
        totalAmount: 0.0,
      );
}


