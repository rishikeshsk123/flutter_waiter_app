import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/domain/model/product/product.dart';

class ScreenCart extends StatelessWidget {
  const ScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text("Your cart is Empty"),
            );
          }
          return Column(
            children: [
              // DropDown for order type
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: state.orderType,
                  decoration: InputDecoration(
                    labelText: "Select Order Type here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Dine In', child: Text("Dine In")),
                    DropdownMenuItem(
                        value: 'Takeaway', child: Text("Takeaway")),
                    DropdownMenuItem(
                        value: 'Delivery', child: Text("Delivery")),
                    DropdownMenuItem(value: 'Rooms', child: Text("Rooms")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<CartBloc>()
                          .add(CartEvent.updateOrderType(value));
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = state.items[index];
                    return ListTile(
                      title: Text(cartItem.name),
                      subtitle: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, productState) {
                          final productItem = productState.products.firstWhere(
                              (prod) => prod.name == cartItem.name,
                              orElse: () => const Product(
                                  id: "",
                                  name: "Unknown Product",
                                  price: 0.0,
                                  description: "Product not found",
                                  img: "",
                                  category: "",
                                  asp: false)
                                  );

                          if (productItem.name != cartItem.name) {
                            return const Text("Product not found");
                          }

                          return 
                          Text(
                                  'Price: \$${productItem.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              final quantity = cartItem.quantity - 1;

                              context.read<CartBloc>().add(
                                    quantity == 0
                                        ? CartEvent.removeItem(cartItem.name)
                                        : CartEvent.updateQuantity(
                                            cartItem.name, quantity),
                                  );
                            },
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                    CartEvent.updateQuantity(
                                        cartItem.name, cartItem.quantity + 1),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Service Charge: \$${state.serviceCharge.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: \$${(state.totalAmount + state.serviceCharge).toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Print"))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
