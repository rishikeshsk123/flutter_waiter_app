import 'package:flutter/material.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/presentation/dine_in/widgets/product_tile_widget.dart';

class ItemListWidget extends StatelessWidget {
  
  ItemListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {

        final products = state.filteredProducts.isNotEmpty
        ? state.filteredProducts
        : state.products;
        
        if (products.isEmpty) {
          return const Center(
            child: Text("No products available."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductTileWidget(product: product);
          },
        );
      },
    );
  }
}

