// ============================================================================
// Screen: CartPage
// Displays all items added to the shopping cart, calculates total amounts,
// allows individual item deletion, and processes the checkout action.
// ============================================================================

import 'package:flutter/material.dart'; // Standard Flutter UI toolkit.
import '../data/categories.dart'; // Category helpers for icons and color accents.
import '../data/market_store.dart'; // In-memory cart and catalog store.
import '../models/product.dart'; // CartItem and Product data models.

// StatefulWidget is used because removing items and clearing the cart requires UI updates.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Removes a specific product item from the cart.
  void _removeItem(String productId) {
    setState(() {
      MarketStore.removeFromCart(productId); // Deletes item from in-memory cart.
    });
  }

  // Handles checkout completion by clearing the cart and notifying the user.
  void _handleCheckout() {
    if (MarketStore.cart.isEmpty) return; // Ignore if cart is already empty.

    // Calculate final total before clearing.
    final double finalTotal = MarketStore.cartTotal;

    setState(() {
      MarketStore.clearCart(); // Empties all items in the cart store.
    });

    // Display a success confirmation message at the bottom.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout successful for \$${finalTotal.toStringAsFixed(1)}!'),
        backgroundColor: const Color(0xFF059669), // Positive green feedback color.
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve latest cart items list and total cost from the store.
    final List<CartItem> cartItems = MarketStore.cart;
    final double totalAmount = MarketStore.cartTotal;

    return Scaffold(
      backgroundColor: Colors.white, // Clean white screen background.
      appBar: AppBar(
        backgroundColor: Colors.white, // Flat white app bar background.
        elevation: 0, // No drop shadow.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back button.
          onPressed: () => Navigator.pop(context), // Returns to home screen.
        ),
        title: const Text(
          'Your cart', // App bar title matching mockup design.
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title.
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)), // Subtle divider line.
        ),
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            // Empty State view when cart contains no items.
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            // Populated State view displaying cart items list.
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemCount: cartItems.length, // Number of unique items in cart.
                itemBuilder: (context, index) {
                  final item = cartItems[index]; // Current cart item.
                  final productColor = colorForCategory(item.product.category);
                  final productIcon = iconForCategory(item.product.category);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        // Leading container with category icon and tinted background.
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: productColor.withValues(alpha: 0.15), // Light background tint.
                            borderRadius: BorderRadius.circular(12), // Rounded corners.
                          ),
                          child: Center(
                            child: Icon(
                              productIcon,
                              size: 26,
                              color: productColor, // Category accent color.
                            ),
                          ),
                        ),
                        const SizedBox(width: 14), // Spacing between icon and title.
                        // Expanded column displaying product name and quantity.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Qty ${item.quantity}', // Quantity indicator.
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Trailing delete button to remove this item from the cart.
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.grey.shade500, // Subdued grey trash icon.
                          ),
                          onPressed: () => _removeItem(item.product.id), // Remove item.
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      // Bottom navigation container displaying the total summary and Checkout button.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1.0), // Top border divider.
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Takes only necessary vertical space.
            children: [
              // Row showing "Total" label and calculated sum amount.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600, // Grey "Total" label.
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(1)}', // Calculated grand total.
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Prominent bold black total.
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Spacing before checkout button.
              // Checkout button with outlined rounded design matching Image 4.
              SizedBox(
                width: double.infinity, // Full available width.
                height: 50,
                child: OutlinedButton(
                  onPressed: cartItems.isEmpty ? null : _handleCheckout, // Trigger checkout.
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300, width: 1.2), // Light border.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners.
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Dark black text label.
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
