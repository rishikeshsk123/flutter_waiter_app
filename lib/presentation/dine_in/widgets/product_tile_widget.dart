import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/domain/model/product/product.dart';
import 'package:restaurant_app/presentation/dine_in/widgets/cart_action_widget.dart';

class ProductTileWidget extends StatelessWidget {
  const ProductTileWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Image part
      leading: const ProductImageWidget(),

      // Item name and price
      title: Text(
        product.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),

      subtitle: product.asp
          ? SizedBox(
              width: 100,
              child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: '\$${product.defaultPrice.toStringAsFixed(2)}'),
                  onChanged: (value) {
                    final newPrice = double.tryParse(value);
                    if (newPrice != null && newPrice > 0) {
                      return context.read<ProductBloc>().add(
                            ProductEvent.updatePriceForASP(
                                product.name, newPrice),
                          );
                    }
                    else {
                      return context.read<ProductBloc>().add(
                            ProductEvent.updatePriceForASP(
                                product.name, product.defaultPrice),
                          );
                    }
                  }),
            )
          : Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kBlueColor,
              ),
            ),

      // Add and remove icons with quantity TextField
      trailing: CartActionWidget(product: product),
    );
  }
}

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 60,
        width: 60,
        color: kGreyColor,
      ),
    );
  }
}
