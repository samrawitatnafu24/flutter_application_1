// ============================================================================
// Main Entry Point & Home Catalog Screen
// This file initializes the Flutter application and renders the primary
// product catalog grid with navigation to cart, product details, and creation.
// ============================================================================

import 'package:flutter/material.dart'; // Core Flutter UI toolkit.
import 'data/market_store.dart'; // Centralized in-memory store for products & cart.
import 'screens/add_product.dart'; // Screen to add or edit products.
import 'screens/cart_page.dart'; // Screen displaying items in the shopping cart.
import 'screens/product_card.dart'; // Reusable card widget for individual products.
import 'screens/product_details.dart'; // Screen displaying product details and purchase actions.

// ----------------------------------------------------------------------------
// Section 1: Application Entry Point
// ----------------------------------------------------------------------------

// main() is the execution starting point of every Dart and Flutter application.
void main() {
  // runApp inflates the root widget (MyApp) and attaches it to the device screen.
  runApp(const MyApp());
}

// MyApp is the root widget of the entire Flutter application.
class MyApp extends StatelessWidget {
  // Const constructor with super.key helps Flutter optimize widget rebuilds.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configures global theme, navigation, and title for the app.
    return MaterialApp(
      title: 'Mini Market', // Application name reported to the operating system.
      debugShowCheckedModeBanner: false, // Hides the 'DEBUG' banner in development mode.
      theme: ThemeData(
        // Use Material 3 design system specifications.
        useMaterial3: true,
        // Set white scaffold background color as the app default.
        scaffoldBackgroundColor: Colors.white,
        // Global color scheme seeded with a modern blue accent.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          surface: Colors.white,
        ),
      ),
      // Set HomePage as the initial screen displayed when the app launches.
      home: const HomePage(),
    );
  }
}

// ----------------------------------------------------------------------------
// Section 2: Home Screen Widget Declaration & State
// ----------------------------------------------------------------------------

// HomePage is a StatefulWidget because dynamic state changes (adding products, cart updates)
// require rebuilding the screen UI.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --------------------------------------------------------------------------
  // Section 3: Navigation & Routing Handlers
  // --------------------------------------------------------------------------

  // Navigates to the CartPage and refreshes the home screen when returning.
  Future<void> _openCart() async {
    // Navigator.push pushes the CartPage route onto the navigation stack.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
    // Refresh the UI to reflect any changes in the cart count badge after returning.
    setState(() {});
  }

  // Navigates to the ProductDetails screen for a specific product ID.
  Future<void> _openProduct({required String id}) async {
    // Passes the selected product's ID to load its specific details.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(productId: id),
      ),
    );
    // Refresh the catalog grid in case the product was updated or deleted.
    setState(() {});
  }

  // Navigates to the AddProduct form screen to create a new product.
  Future<void> _openProductForm() async {
    // Push the AddProduct screen route.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProduct()),
    );
    // Refresh the catalog grid when a new product is added.
    setState(() {});
  }

  // --------------------------------------------------------------------------
  // Section 4: Widget Tree & UI Layout
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Retrieve total cart items count to display in the app bar badge.
    final int itemCount = MarketStore.cartCount;

    // Retrieve the list of all products currently available in the store.
    final products = MarketStore.products;

    return Scaffold(
      backgroundColor: Colors.white, // Clean white background matching design mockups.
      appBar: AppBar(
        backgroundColor: Colors.white, // White app bar background.
        elevation: 0, // Flat design with no drop shadow.
        title: const Text(
          'Mini Market', // App header title.
          style: TextStyle(
            color: Colors.black, // High contrast black text.
            fontWeight: FontWeight.bold, // Bold emphasis for title.
            fontSize: 22,
          ),
        ),
        actions: [
          // Badge widget wraps the cart icon to show a number badge if items exist.
          Badge(
            isLabelVisible: itemCount > 0, // Only show the badge pill if items are in the cart.
            label: Text(itemCount.toString()), // Displays the current item count.
            backgroundColor: const Color(0xFF2563EB), // Blue badge background.
            alignment: const AlignmentDirectional(18, -4), // Adjust badge positioning.
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined, // Shopping cart outline icon.
                color: Colors.black, // Black icon color matching mockup.
                size: 26,
              ),
              onPressed: _openCart, // Open cart screen when cart icon is tapped.
            ),
          ),
          const SizedBox(width: 8), // Right margin spacing for the app bar action.
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1), // 1 logical pixel divider height.
          child: Divider(
            height: 1,
            color: Color(0xFFE5E7EB), // Subtle grey divider line below the app bar.
          ),
        ),
      ),
      body: SafeArea(
        // SafeArea prevents content from overlapping status bars or device bezels.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 16px outer margin around the grid.
          child: GridView.builder(
            itemCount: products.length, // Total number of products to render in the grid.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 equal columns grid.
              mainAxisSpacing: 14, // Vertical spacing between rows.
              crossAxisSpacing: 14, // Horizontal spacing between columns.
              childAspectRatio: 0.85, // Width to height aspect ratio of each card.
            ),
            itemBuilder: (BuildContext context, int index) {
              // Retrieve the product instance for the current grid index.
              final product = products[index];

              // Return ProductCard widget with an onTap callback to open details.
              return ProductCard(
                product: product,
                onTap: () => _openProduct(id: product.id), // Open details when tapped.
              );
            },
          ),
        ),
      ),
      // FloatingActionButton positioned at the bottom right to quickly add a product.
      floatingActionButton: FloatingActionButton(
        onPressed: _openProductForm, // Triggers AddProduct navigation.
        backgroundColor: const Color(0xFFE0E7FF), // Soft light indigo/lavender background matching design.
        foregroundColor: const Color(0xFF4338CA), // Deep indigo plus icon color.
        elevation: 2, // Subtle elevation shadow.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded square FAB shape.
        ),
        child: const Icon(Icons.add, size: 28), // Plus icon inside button.
      ),
    );
  }
}
