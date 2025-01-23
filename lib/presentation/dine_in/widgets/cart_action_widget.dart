import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/domain/model/cart/cart_item.dart';
import 'package:restaurant_app/domain/model/product/product.dart';
import 'package:restaurant_app/presentation/dine_in/widgets/quantity_field_widget.dart';

class CartActionWidget extends StatelessWidget {
  const CartActionWidget({
    super.key,
    required this.product,
  });

  final Product product;

  void _addItemQuantity(BuildContext ctx) {
    final currentItem = ctx.read<CartBloc>().state.items.firstWhere(
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

    // if (
    //     currentItem.price! <= 0) {
    //   ScaffoldMessenger.of(ctx).showSnackBar(
    //     const SnackBar(
    //       content:
    //           Text("Please set a valid price first!"),
    //     ),
    //   );
    //   return;
    // }

    if (currentItem.quantity == 0) {
      ctx.read<CartBloc>().add(
            CartEvent.addItem(
              product,
            ),
          );
    }

    ctx.read<CartBloc>().add(
          CartEvent.updateQuantity(product.name, currentItem.quantity + 1),
        );
  }

  void _removeItemQuantity(BuildContext ctx) {
    final currentItem = ctx.read<CartBloc>().state.items.firstWhere(
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

    // if (currentItem.price == null ||
    //     currentItem.price! <= 0) {
    //   ScaffoldMessenger.of(ctx).showSnackBar(
    //     const SnackBar(
    //         content:
    //             Text("Please set a valid price first!")),
    //   );
    //   return;
    // }

    if (currentItem.quantity > 1) {
      // Reduce quantity by 1
      ctx.read<CartBloc>().add(
            CartEvent.updateQuantity(product.name, currentItem.quantity - 1),
          );
    } else {
      // Remove the item from the cart if quantity is 1
      ctx.read<CartBloc>().add(
            CartEvent.removeItem(product.name),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => _removeItemQuantity(context),
        ),
        QuantityFieldWidget(product: product),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _addItemQuantity(context),
        ),
      ],
    );
  }
}
