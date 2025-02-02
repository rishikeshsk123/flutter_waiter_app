import 'package:flutter/material.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/presentation/home/widgets/product_tile_widget.dart';

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

        return LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;

            // Set the number of columns dynamically based on screen width
            int crossAxisCount = 1;
            if (screenWidth > 1200) {
              crossAxisCount = 2; // 2 columns for Desktop
            } else if (screenWidth > 800) {
              crossAxisCount = 2; // 2 columns for Tablet
            } else {
              crossAxisCount = 1; // Single column for Mobile
            }

            // Calculate the maximum width of each item
            final double itemWidth = screenWidth > 800
                ? (screenWidth / 2) - 16 // Ensure two columns for Desktop
                : (screenWidth - ((crossAxisCount - 1) * 8)) / crossAxisCount;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align to the top
                  children: [
                    Wrap(
                      spacing: 8, // Horizontal spacing between items
                      runSpacing: 8, // Vertical spacing between rows
                      alignment:
                          WrapAlignment.start, // Start items from the top left
                      children: products.map((product) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: itemWidth, // Ensure maximum width per item
                          ),
                          child: ProductTileWidget(product: product),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
