// ============================================================================
// Model: Product and CartItem
// This file defines the core data structures used throughout the Mini Market app.
// ============================================================================

// The Product class models an individual item sold in the market.
class Product {
  // Unique identifier for each product (e.g., 'p1', 'p2').
  final String id;

  // The display name / title of the product (e.g., 'Phone X').
  final String title;

  // Detailed description of the product's features or specs.
  final String description;

  // Category identifier to group products (e.g., 'smartphones', 'audio').
  final String category;

  // Retail price of the product as a decimal number.
  final double price;

  // Const constructor creates immutable product instances with named required fields.
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
  });

  // copyWith allows creating a new Product instance with modified fields
  // while preserving all other existing property values unchanged.
  Product copyWith({
    String? title,
    String? description,
    String? category,
    double? price,
  }) {
    return Product(
      id: id, // The id remains the same when updating a product.
      title: title ?? this.title, // Use new title if provided, otherwise keep existing.
      description: description ?? this.description, // Use new description if provided.
      category: category ?? this.category, // Use new category if provided.
      price: price ?? this.price, // Use new price if provided.
    );
  }
}

// The CartItem class represents a product added to the user's shopping cart
// along with the desired quantity.
class CartItem {
  // Reference to the product being purchased.
  final Product product;

  // The number of units of this product currently in the cart.
  int quantity;

  // Constructor initializing the product reference and starting quantity.
  CartItem({
    required this.product,
    required this.quantity,
  });

  // Computed property getter calculating the total cost for this cart line item.
  double get total => product.price * quantity;
}
