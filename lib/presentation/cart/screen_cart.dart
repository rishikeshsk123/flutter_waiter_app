import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/domain/model/product/product.dart';

class ScreenCart extends StatelessWidget {
  const ScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate scalable font sizes
    // Define breakpoints for responsiveness
    final bool isMobile = screenWidth <= 600;
    final bool isTablet = screenWidth > 600 && screenWidth <= 1200;

    final double appBarFontSize = screenHeight * 0.04;

    final double titleFontSize = isMobile
        ? 24
        : isTablet
            ? 28
            : 32; // Larger font size for tablet and desktop
    final double grantTotalFontSize = isMobile
        ? 18
        : isTablet
            ? 20
            : 22;
    final double headerFontSize = isMobile
        ? 16
        : isTablet
            ? 18
            : 20; // Larger font size for tablet and desktop
    final double bodyFontSize = isMobile
        ? 14
        : isTablet
            ? 16
            : 18;
    final double buttonFontSize = isMobile
        ? 18
        : isTablet
            ? 20
            : 22; // Larger font size for tablet and desktop

    final double billPadding = isMobile
        ? 20
        : isTablet
            ? 300
            : 480;

    // Calculate scalable padding and margins
    // final double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final double verticalPadding = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: appBarFontSize,
              color: kBlackColor),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Text(
                "Your cart is Empty",
                style: TextStyle(fontSize: headerFontSize),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: billPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Text("Hotel XYZ",
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold)),
                        Text("GSTIN: 1234567890ABC",
                            style: TextStyle(fontSize: headerFontSize)),
                        Text("Bill No: 00123",
                            style: TextStyle(fontSize: headerFontSize)),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),

                  // Table Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 2))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Item",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headerFontSize,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Qty",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headerFontSize,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Each Price",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headerFontSize,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headerFontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bill Items (Scrollable inside SingleChildScrollView)
                  ListView.separated(
                    shrinkWrap:
                        true, // Ensures ListView takes only required space
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents independent scrolling
                    itemCount: state.items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final cartItem = state.items[index];
                      final product =
                          context.read<ProductBloc>().state.products.firstWhere(
                                (prod) => prod.id == cartItem.productId,
                                orElse: () => const Product(
                                    id: "",
                                    name: "Unknown",
                                    price: 0,
                                    description: "",
                                    img: "",
                                    category: "",
                                    asp: false,
                                    defaultPrice: 0.0),
                              );

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Text(cartItem.name,
                                          style: TextStyle(
                                              fontSize: bodyFontSize)))),
                              Expanded(
                                  child: Center(
                                      child: Text("${cartItem.quantity}",
                                          style: TextStyle(
                                              fontSize: bodyFontSize)))),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          "₹${product.price.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: bodyFontSize)))),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          "₹${(cartItem.quantity * product.price).toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: bodyFontSize,
                                              fontWeight: FontWeight.bold)))),
                            ],
                          ),
                          // const Divider(thickness: 1),
                        ],
                      );
                    },
                  ),

                  // Bill Summary (Appears at the end of ListView)
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(verticalPadding),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Subtotal:",
                                style: TextStyle(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold)),
                            Text("₹${state.totalAmount.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: headerFontSize)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Service Charge:",
                                style: TextStyle(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold)),
                            Text("₹${state.serviceCharge.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: headerFontSize)),
                          ],
                        ),
                        const Divider(thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Grand Total:",
                                style: TextStyle(
                                    fontSize: grantTotalFontSize,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "₹${(state.totalAmount + state.serviceCharge).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: grantTotalFontSize,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Print Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement Print Functionality
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        textStyle: TextStyle(
                            fontSize: buttonFontSize, fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Print Bill"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
