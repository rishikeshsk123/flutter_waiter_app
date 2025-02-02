import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/domain/model/cart/cart_item.dart';
import 'package:restaurant_app/domain/model/product/product.dart';

class QuantityFieldWidget extends StatelessWidget {
  const QuantityFieldWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) {
          // Rebuild only when the quantity for this product changes
          final prevItem = previous.items.firstWhere(
            (item) => item.name == product.name,
            orElse: () => CartItem(
              name: product.name,
              price: product.price,
              quantity: 0,
              asp: product.asp,
              defaultPrice: product.defaultPrice,
              productId: product.id,
            ),
          );
          final currItem = current.items.firstWhere(
            (item) => item.name == product.name,
            orElse: () => CartItem(
              name: product.name,
              price: product.price,
              quantity: 0,
              asp: product.asp,
              defaultPrice: product.defaultPrice,
              productId: product.id,
            ),
          );
          return prevItem.quantity != currItem.quantity;
        },
        builder: (context, state) {
          final cartItem = state.items.firstWhere(
            (item) => item.name == product.name,
            orElse: () => CartItem(
              name: product.name,
              price: product.price,
              quantity: 0,
              asp: product.asp,
              defaultPrice: product.defaultPrice,
              productId: product.id,
            ),
          );

          // create TextEditingcontroller with current quantity

          final textController = TextEditingController(
            text: cartItem.quantity.toString(),
          );

          return TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: textController,
            onSubmitted: (value) {
              final newQuantity = int.tryParse(value) ?? 0;

              if (newQuantity == 0) {
                context
                    .read<CartBloc>()
                    .add(CartEvent.removeItem(cartItem.productId));
              } else {
                if (cartItem.quantity == 0) {
                  context.read<CartBloc>().add(
                        CartEvent.addItem(
                          product,
                        ),
                      );
                }
                context
                    .read<CartBloc>()
                    .add(CartEvent.updateQuantity(cartItem.productId, newQuantity));
              }

              if (textController.text.isEmpty) {
                textController.text = '0';
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quantity cannot be negative'),
                  ),
                );
              }
            },
            onTap: () {
              textController.selection = TextSelection(
                baseOffset: 1,
                extentOffset: textController.text.length,
              );
            },
          );
        },
      ),
    );
  }
}
