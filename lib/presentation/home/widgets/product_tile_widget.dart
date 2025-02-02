import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/domain/model/product/product.dart';
import 'package:restaurant_app/presentation/home/widgets/cart_action_widget.dart';

class ProductTileWidget extends StatelessWidget {
  const ProductTileWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the available screen width

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth <= 600;
    final bool isTablet = screenWidth > 600 && screenWidth <= 1200;
    // final bool isDesktop = screenWidth > 1200;

    final double titleFontSize = isMobile
        ? 18
        : isTablet
            ? 20
            : 22;
    final double priceFontSize = isMobile
        ? 14
        : isTablet
            ? 16
            : 18;
            
    // Adjust layout based on screen width
    if (screenWidth > 600) {
      // Tablet and Desktop layout
      return _buildWideLayout(
        context,
        titleFontSize,
        priceFontSize,
      );
    } else {
      // Mobile layout
      return _buildCompactLayout(
        context,
        titleFontSize,
        priceFontSize,
      );
    }
  }

  // Compact layout for mobile
  Widget _buildCompactLayout(
      BuildContext context, double titleFontSize, double priceFontSize) {
    return ListTile(
      // Image part
      leading: const ProductImageWidget(),

      // Item name and price
      title: Text(
        product.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: titleFontSize,
        ),
      ),

      subtitle: product.asp
          ? SizedBox(
              width: 100,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '₹${product.defaultPrice.toStringAsFixed(2)}',
                ),
                onChanged: (value) {
                  final newPrice = double.tryParse(value);
                  if (newPrice != null && newPrice > 0) {
                    context.read<ProductBloc>().add(
                          ProductEvent.updatePriceForASP(product.id, newPrice),
                        );
                  } else {
                    context.read<ProductBloc>().add(
                          ProductEvent.updatePriceForASP(
                              product.id, product.defaultPrice),
                        );
                  }
                },
              ),
            )
          : Text(
              "₹${product.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: priceFontSize,
                color: kBlueColor,
              ),
            ),

      // Add and remove icons with quantity TextField
      trailing: CartActionWidget(product: product),
    );
  }

  // Wide layout for tablet and desktop
  Widget _buildWideLayout(
    BuildContext context,
    double titleFontSize,
    double priceFontSize,
  ) {
    return  ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 600), // Set your maximum width here
  child: Card(
    elevation: 4,
    margin: const EdgeInsets.all(8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Image part
          const ProductImageWidget(),

          const SizedBox(width: 16),

          // Item name and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
                const SizedBox(height: 8),
                product.asp
                    ? SizedBox(
                        width: 150,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:
                                '₹${product.defaultPrice.toStringAsFixed(2)}',
                          ),
                          onChanged: (value) {
                            final newPrice = double.tryParse(value);
                            if (newPrice != null && newPrice > 0) {
                              context.read<ProductBloc>().add(
                                    ProductEvent.updatePriceForASP(
                                        product.id, newPrice),
                                  );
                            } else {
                              context.read<ProductBloc>().add(
                                    ProductEvent.updatePriceForASP(
                                        product.id, product.defaultPrice),
                                  );
                            }
                          },
                        ),
                      )
                    : Text(
                        "₹${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: priceFontSize,
                          color: kBlueColor,
                        ),
                      ),
              ],
            ),
          ),

          // Add and remove icons with quantity TextField
          CartActionWidget(product: product),
        ],
      ),
    ),
  ),
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
        height: 90,
        width: 90,
        color: kGreyColor,
      ),
    );
  }
}
