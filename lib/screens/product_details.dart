// ============================================================================
// Screen: ProductDetails
// Displays detailed specifications for a selected product, allows adjusting
// purchase quantity, adding items to the cart, editing, and deleting.
// ============================================================================

import 'package:flutter/material.dart'; // Flutter Material Design components.
import '../data/categories.dart'; // Category helper functions for icons & colors.
import '../data/market_store.dart'; // Centralized in-memory store.
import '../models/product.dart'; // Product and CartItem data models.
import 'add_product.dart'; // Add / Edit product form screen.

// StatefulWidget is used because quantity selection and product editing require dynamic UI state updates.
class ProductDetails extends StatefulWidget {
  // The unique ID of the product to display.
  final String productId;

  // Constructor requiring the productId to fetch product data from the store.
  const ProductDetails({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // State variable tracking the quantity of units the user intends to add to cart.
  int _quantity = 1;

  // Decreases the quantity counter down to a minimum of 1.
  void _decrementQty() {
    if (_quantity > 1) {
      setState(() {
        _quantity--; // Decrease quantity by 1.
      });
    }
  }

  // Increases the quantity counter by 1.
  void _incrementQty() {
    setState(() {
      _quantity++; // Increase quantity by 1.
    });
  }

  // Opens the AddProduct screen prefilled in edit mode.
  Future<void> _editProduct(Product product) async {
    // Navigate to AddProduct screen passing the existing product.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduct(product: product),
      ),
    );
    // After returning from the edit screen, rebuild to display updated product details.
    setState(() {});
  }

  // Deletes the product from the store and returns to the home catalog.
  void _deleteProduct(Product product) {
    // Show a confirmation dialog before permanently deleting.
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product'), // Dialog title.
          content: Text('Are you sure you want to delete "${product.title}"?'), // Confirmation message.
          actions: [
            // Cancel button dismisses the dialog.
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            // Delete button removes the product and pops screens.
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Dismiss dialog.
                MarketStore.deleteProduct(product.id); // Remove from store.
                Navigator.pop(context); // Return to home screen.
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Adds the current product and chosen quantity to the shopping cart.
  void _addToCart(Product product) {
    // Add item to MarketStore cart.
    MarketStore.addToCart(product, _quantity);

    // Show a brief confirmation snackbar notification at the bottom.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity "${product.title}" to cart!'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2563EB),
      ),
    );

    // Return to the home screen after adding.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Look up the latest product details from the store by productId.
    final Product? product = MarketStore.findProduct(widget.productId);

    // If the product was deleted or does not exist, display a fallback screen.
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Not Found')),
        body: const Center(child: Text('This product no longer exists.')),
      );
    }

    // Resolve visual styling based on product category.
    final Color productColor = colorForCategory(product.category);
    final IconData productIcon = iconForCategory(product.category);

    return Scaffold(
      backgroundColor: Colors.white, // Clean white screen background.
      appBar: AppBar(
        backgroundColor: Colors.white, // Clean white app bar.
        elevation: 0, // Flat app bar without shadow.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow button.
          onPressed: () => Navigator.pop(context), // Pops current route to go back.
        ),
        title: Text(
          product.title, // Displays product title in the header.
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center title horizontally in the AppBar.
        actions: [
          // Edit product action button.
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black87),
            onPressed: () => _editProduct(product), // Trigger edit workflow.
          ),
          // Delete product action button.
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
            onPressed: () => _deleteProduct(product), // Trigger delete workflow.
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1), // 1px height divider line.
          child: Divider(height: 1, color: Color(0xFFE5E7EB)), // Subtle separator.
        ),
      ),
      body: SafeArea(
        // SafeArea ensures content is not obscured by system notches or home indicators.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align elements to left.
            children: [
              // Large hero banner container with tinted category background and icon.
              Container(
                width: double.infinity, // Span full available width.
                height: 220, // Fixed height for hero image box.
                decoration: BoxDecoration(
                  color: productColor.withValues(alpha: 0.12), // Subtle category tint.
                  borderRadius: BorderRadius.circular(20), // Large rounded corners.
                ),
                child: Center(
                  child: Icon(
                    productIcon, // Category icon.
                    size: 80, // Large prominent icon display.
                    color: productColor, // Vibrant category accent color.
                  ),
                ),
              ),
              const SizedBox(height: 24), // Vertical spacing.
              // Product Title display.
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8), // Spacing between title and price.
              // Formatted price with 1 decimal place.
              Text(
                '\$${product.price.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB), // Signature blue color matching mockups.
                ),
              ),
              const SizedBox(height: 12), // Spacing before description.
              // Product description paragraph.
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5, // Line height for comfortable reading.
                  color: Colors.grey.shade600, // Medium grey subtitle color.
                ),
              ),
              const SizedBox(height: 24), // Spacing before quantity selector.
              // Row containing quantity selector controls.
              Row(
                children: [
                  Text(
                    'Qty',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16), // Space before minus button.
                  // Decrement quantity button container.
                  InkWell(
                    onTap: _decrementQty, // Triggers decrement method.
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300), // Light grey outline.
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.remove, size: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between button and counter text.
                  // Current quantity display.
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16), // Space between counter text and plus button.
                  // Increment quantity button container.
                  InkWell(
                    onTap: _incrementQty, // Triggers increment method.
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300), // Light grey outline.
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, size: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(), // Pushes the "Add to cart" button to the bottom of the screen.
              // Full-width Add to Cart button.
              SizedBox(
                width: double.infinity, // Full available width.
                height: 52, // Ergonomic tap height.
                child: ElevatedButton(
                  onPressed: () => _addToCart(product), // Calls add to cart logic.
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // Signature primary blue.
                    elevation: 0, // Flat modern design.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded button edges.
                    ),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Crisp white label.
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Bottom padding for navigation clearance.
            ],
          ),
        ),
      ),
    );
  }
}
