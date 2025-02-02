import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/presentation/cart/screen_cart.dart';
import 'package:restaurant_app/presentation/home/widgets/item_list_widget.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ProductBloc>(context).add((ProductEvent.fetchProducts()));
    });

    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    final bool isMobile = screenWidth <= 600;
    // final bool isTablet = screenWidth > 600 && screenWidth <= 1200;
    // final bool isDesktop = screenWidth > 1200;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final categoryList = state.categories;

        if (isMobile) {
          return MobileLayout(categoryList: categoryList);
        } else {
          return TabletDesktopLayout(categoryList: categoryList);
        }
      },
    );
  }
}

// Mobile Layout
class MobileLayout extends StatelessWidget {
  final List<String> categoryList;

  const MobileLayout({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarFontSize = screenHeight * 0.04;
    
    final double cartIconSize = screenHeight * 0.04;

    return DefaultTabController(
      length: categoryList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Menu',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: appBarFontSize,
              color: kBlueColor[700],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => ScreenCart()),
                );
              },
              icon: Icon(
                Icons.shopping_cart_checkout_outlined,
                color: kBlueColor,
                size: cartIconSize,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(180),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        value: state.orderType,
                        decoration: InputDecoration(
                          labelText: "Select Order Type here",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Dine In',
                            child: Text("Dine In"),
                          ),
                          DropdownMenuItem(
                            value: 'Takeaway',
                            child: Text("Takeaway"),
                          ),
                          DropdownMenuItem(
                            value: 'Delivery',
                            child: Text("Delivery"),
                          ),
                          DropdownMenuItem(
                            value: 'Rooms',
                            child: Text("Rooms"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<CartBloc>()
                                .add(CartEvent.updateOrderType(value));
                          }
                        },
                      );
                    },
                  ),
                ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: kBlackColor,
                  tabs: categoryList
                      .map((category) => Tab(text: category))
                      .toList(),
                  onTap: (index) {
                    final selectCategory = categoryList[index];
                    context.read<ProductBloc>().add(
                          ProductEvent.filterByCategory(selectCategory),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: categoryList.map((category) {
            return ItemListWidget();
          }).toList(),
        ),
      ),
    );
  }
}

// Tablet and Desktop Layout
class TabletDesktopLayout extends StatelessWidget {
  final List<String> categoryList;

  const TabletDesktopLayout({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarFontSize = screenHeight * 0.04;
    final double cartIconSize = screenHeight * 0.045;

    return Scaffold(
      
      body: Column(
        
        children: [
          // Placeholder for window controls (simulating space for close button)
          Container(
            height: 32, // Adjust height based on system UI
            color: Colors.grey, // Can change based on theme
          ),

          // AppBar (positioned below the window controls)
           AppBar(
        title: Text(
          'Menu',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: appBarFontSize,
            color: kBlueColor[700],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => ScreenCart()),
              );
            },
            icon: Icon(
              Icons.shopping_cart_checkout_outlined,
              color: kBlueColor,
              size: cartIconSize,
            ),
          ),
        ],
      ),
          Expanded(
            child: Row(
              children: [
                // Sidebar with Horizontal Scrolling if Needed
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth / 4.2, // Minimum sidebar width
                      maxWidth: screenWidth / 3.8, // Prevents excessive width
                    ),
                    child: Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Dropdown for Order Type
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              return DropdownButtonFormField<String>(
                                value: state.orderType,
                                decoration: InputDecoration(
                                  labelText: "Select Order Type here",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Dine In',
                                    child: Text("Dine In"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Takeaway',
                                    child: Text("Takeaway"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Delivery',
                                    child: Text("Delivery"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Rooms',
                                    child: Text("Rooms"),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<CartBloc>()
                                        .add(CartEvent.updateOrderType(value));
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
            
                          // Search Bar
                          CupertinoSearchTextField(
                            placeholder: "Search here...",
                            onChanged: (query) {
                              context.read<ProductBloc>().add(
                                    ProductEvent.searchProducts(query),
                                  );
                            },
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          const SizedBox(height: 16),
            
                          // Category List with Vertical Scrolling
                          Expanded(
                            child: ListView.builder(
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) {
                                final category = categoryList[index];
                                return ListTile(
                                  title: Text(category),
                                  onTap: () {
                                    context.read<ProductBloc>().add(
                                          ProductEvent.filterByCategory(category),
                                        );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
                // Main Content
                Expanded(
                  child: ItemListWidget(), // Replace with your main content widget
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


