// ============================================================================
// Store: MarketStore (In-Memory State & Data Store)
// Acts as a centralized singleton store to manage the products catalog and cart state.
// ============================================================================

import '../models/product.dart'; // Imports the Product and CartItem data models.

class MarketStore {
  // Private constructor prevents external instantiation since all methods/state are static.
  MarketStore._();

  // The primary in-memory list holding all available products in the store.
  static final List<Product> products = [
    const Product(
      id: 'p1', // Unique ID.
      title: 'Phone X', // Product title.
      price: 549.0, // Product unit price.
      category: 'smartphones', // Associated category.
      description: '6.1-inch display, 128 GB storage, dual camera.', // Detailed specs.
    ),
    const Product(
      id: 'p2',
      title: 'Headphones',
      price: 89.0,
      category: 'audio',
      description: 'Over-ear headphones with 30 hours of battery life.',
    ),
    const Product(
      id: 'p3',
      title: 'T-shirt',
      price: 15.0,
      category: 'clothing',
      description: '100% cotton, regular fit, machine washable.',
    ),
    const Product(
      id: 'p4',
      title: 'Laptop',
      price: 899.0,
      category: 'computers',
      description: '14-inch laptop, 16 GB RAM, 512 GB SSD.',
    ),
    const Product(
      id: 'p5',
      title: 'Camera',
      price: 320.0,
      category: 'photography',
      description: 'Compact camera with 20x optical zoom.',
    ),
    const Product(
      id: 'p6',
      title: 'Backpack',
      price: 42.0,
      category: 'accessories',
      description: 'Water resistant backpack with a laptop pocket.',
    ),
  ];

  // The shopping cart list containing items the user has added to purchase.
  static final List<CartItem> cart = [];

  // Finds and returns a Product matching the provided ID, or null if not found.
  static Product? findProduct(String id) {
    for (final product in products) {
      if (product.id == id) {
        return product; // Found matching product.
      }
    }
    return null; // No product found with this ID.
  }

  // Adds a newly created Product to the catalog list.
  static void addProduct(Product product) {
    products.add(product); // Appends the new item to the products list.
  }

  // Updates an existing Product in the catalog and synchronizes any cart instances.
  static void updateProduct(Product updated) {
    // Find the index of the product being updated.
    final index = products.indexWhere((product) => product.id == updated.id);
    if (index == -1) return; // Exit if product does not exist.
    
    // Replace the product at that index with the updated version.
    products[index] = updated;

    // Also update this product in the cart if the user has added it.
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].product.id == updated.id) {
        cart[i] = CartItem(
          product: updated, // Updated product details.
          quantity: cart[i].quantity, // Preserved quantity.
        );
      }
    }
  }

  // Deletes a product from the catalog by ID and removes it from the cart as well.
  static void deleteProduct(String id) {
    // Removes the product from the main catalog list.
    products.removeWhere((product) => product.id == id);
    // Removes the product from the cart list if present.
    cart.removeWhere((item) => item.product.id == id);
  }

  // Generates a unique product ID based on current timestamp in milliseconds.
  static String newProductId() {
    return 'p${DateTime.now().millisecondsSinceEpoch}';
  }

  // Adds a product to the cart with a specified quantity.
  // If the product is already in the cart, it increments its existing quantity.
  static void addToCart(Product product, int quantity) {
    // Search for an existing cart item with the same product ID.
    final index = cart.indexWhere((item) => item.product.id == product.id);
    
    if (index == -1) {
      // Product is not yet in the cart; add a new CartItem entry.
      cart.add(CartItem(product: product, quantity: quantity));
    } else {
      // Product is already in the cart; increment the existing quantity.
      cart[index].quantity += quantity;
    }
  }

  // Removes a specific product from the cart completely by product ID.
  static void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
  }

  // Clears all items from the shopping cart (e.g., when checkout is completed).
  static void clearCart() {
    cart.clear(); // Empties the cart list.
  }

  // Computed property getter returning total count of all items in the cart.
  static int get cartCount {
    int count = 0; // Running tally of item quantities.
    for (final item in cart) {
      count += item.quantity; // Add quantity of each cart item.
    }
    return count; // Return total items count.
  }

  // Computed property getter returning the sum total price of all items in the cart.
  static double get cartTotal {
    double total = 0.0; // Running total sum in dollars.
    for (final item in cart) {
      total += item.total; // Add total for each line item (price * quantity).
    }
    return total; // Return cumulative price.
  }
}
