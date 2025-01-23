part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.addItem(Product product) = _AddItem;
  const factory CartEvent.removeItem(String productId) = _RemoveItem;
  const factory CartEvent.updateQuantity(String productId, int quantity) =
      _UpdateQuantity;
  const factory CartEvent.updateOrderType(String orderType) = _UpdateOrderType;
  const factory CartEvent.clearCart() = _ClearCart;
}
