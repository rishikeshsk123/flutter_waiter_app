import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/presentation/cart/screen_cart.dart';
import 'package:restaurant_app/presentation/dine_in/widgets/item_list_widget.dart';

class ScreenDineIn extends StatelessWidget {
  const ScreenDineIn({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ProductBloc>(context).add((ProductEvent.fetchProducts()));
    });
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final categoryList = state.categories;
        return DefaultTabController(
          length: categoryList.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Menu',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: kBlueColor[700]),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    // Navigate to the cart screen (not implemented here)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => ScreenCart()),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart_checkout_outlined,
                    color: kBlueColor,
                    size: 30,
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CupertinoSearchTextField(
                        placeholder: "Search here...",
                        onChanged: (query) {
                          context.read<ProductBloc>().add(
                                ProductEvent.searchProducts(query),
                              );
                        },
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      unselectedLabelColor: kGreyColor,
                      labelColor: kBlackColor,
                      labelStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      indicatorColor: kBlackColor,
                      tabs: categoryList
                          .map((category) => Tab(text: category))
                          .toList(),
                      onTap: (index) {
                        final selectCategory = categoryList[index];
                        context
                            .read<ProductBloc>()
                            .add(ProductEvent.filterByCategory(selectCategory));
                      },
                      // tabs: [
                      //   Text("1"),
                      //   Text("1"),
                      //   Text("1"),
                      //   Text("1"),
                      //   Text("1"),
                      // ],
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: categoryList.map((category) {
                return ItemListWidget();
              }).toList(),
              // children: [
              //   Text("Hi"),
              //   Text("Hi"),
              //   Text("Hi"),
              //   Text("Hi"),
              //   Text("Hi"),
              // ],
            ),
          ),
        );
      },
    );
  }
}
