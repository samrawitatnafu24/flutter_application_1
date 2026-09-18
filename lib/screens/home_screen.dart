import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

import '../data/market_store.dart';
import 'add_product.dart';
import 'cart_page.dart';
import 'product_card.dart';
import 'product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Open Cart
  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartPage(),
      ),
    );

    setState(() {});
  }

  // Open Product Details
  Future<void> _openProduct({
    required String id,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(
          productId: id,
        ),
      ),
    );

    // Tell BLoC to get the latest products
    if (mounted) {
      context.read<ProductBloc>().add(GetProducts());
    }
  }

  // Open Add Product
  Future<void> _openProductForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProduct(),
      ),
    );

    // Tell BLoC to get the latest products
    if (mounted) {
      context.read<ProductBloc>().add(GetProducts());
    }
  }

  @override
  Widget build(BuildContext context) {

    final int itemCount = MarketStore.cartCount;

    return Scaffold(
      backgroundColor: Colors.white,

      // ------------------------------------------------
      // APP BAR
      // ------------------------------------------------

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Mini Market',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        actions: [

          Badge(
            isLabelVisible: itemCount > 0,

            label: Text(
              itemCount.toString(),
            ),

            backgroundColor: const Color(0xFF2563EB),

            alignment: const AlignmentDirectional(
              18,
              -4,
            ),

            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
                size: 26,
              ),

              onPressed: _openCart,
            ),
          ),

          const SizedBox(width: 8),
        ],

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),

          child: Divider(
            height: 1,
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),

      // ------------------------------------------------
      // PRODUCT LIST
      // ------------------------------------------------

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {

              // LOADING
              if (state is ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // ERROR
              if (state is ProductError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              // PRODUCTS LOADED
              if (state is ProductLoaded) {

                final products = state.products;

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products available',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return GridView.builder(

                  itemCount: products.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    mainAxisSpacing: 14,

                    crossAxisSpacing: 14,

                    childAspectRatio: 0.85,
                  ),

                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {

                    final product = products[index];

                    return ProductCard(

                      product: product,

                      onTap: () {
                        _openProduct(
                          id: product.id,
                        );
                      },
                    );
                  },
                );
              }

              // INITIAL
              return const Center(
                child: Text(
                  'Getting products...',
                ),
              );
            },
          ),
        ),
      ),

      // ------------------------------------------------
      // ADD PRODUCT BUTTON
      // ------------------------------------------------

      floatingActionButton: FloatingActionButton(

        onPressed: _openProductForm,

        backgroundColor: const Color(0xFFE0E7FF),

        foregroundColor: const Color(0xFF4338CA),

        elevation: 2,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}