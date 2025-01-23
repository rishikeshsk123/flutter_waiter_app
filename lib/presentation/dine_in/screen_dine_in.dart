import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/core/constant.dart';
import 'package:restaurant_app/presentation/cart/screen_cart.dart';
import 'package:restaurant_app/presentation/dine_in/widgets/item_list_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenDineIn extends StatelessWidget {
  const ScreenDineIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final categories = [
          'All',
          ...state.products.map((e) => e.category).toSet()
        ];
        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(130),
              child: AppBar(
                title: Text(
                  'Menu',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: kBlueColor[700]),
                ),
                actions: [
                  Stack(
                    children: [
                      
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
                  ),
                ],
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kHeight16,
                      kHeight16,
                      kHeight16,
                      CupertinoSearchTextField(
                        placeholder: 'Search here...',
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.35),
                        ),
                        padding: const EdgeInsets.all(8),
                        prefixIcon: const Icon(
                          CupertinoIcons.search,
                          color: kGreyColor,
                        ),
                        onChanged: (query) {
                          context.read<ProductBloc>().add(
                                ProductEvent.searchProducts(query),
                              );
                        },
                      ),
                      
                      
                    ],
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  unselectedLabelColor: kGreyColor,
                  labelColor: kBlackColor,
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  indicatorColor: kBlackColor,
                  tabs: categories.map((category) {
                    return Tab(text: category);
                  }).toList(),
                  onTap: (index) {
                    final selectCategory = categories[index];
                    context
                        .read<ProductBloc>()
                        .add(ProductEvent.filterByCategory(selectCategory));
                  },
                ),
                elevation: 0,
              ),
            ),
            body: TabBarView(
              children: categories.map((category) {
                return ItemListWidget();
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
