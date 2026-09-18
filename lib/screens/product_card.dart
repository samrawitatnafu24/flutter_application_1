// ============================================================================
// Widget: ProductCard
// Represents an interactive card in the home screen product grid.
// ============================================================================

import 'package:flutter/material.dart'; // Core Flutter UI toolkit.
import '../data/categories.dart'; // Helper functions for category colors and icons.
import '../models/product.dart'; // Product data model.

// ProductCard is a StatelessWidget because its appearance is purely driven by inputs (product & onTap).
class ProductCard extends StatelessWidget {
  // The product model instance displayed by this card.
  final Product product;

  // Optional callback function triggered when the user taps on this card.
  final VoidCallback? onTap;

  // Constructor requiring the product and accepting an optional onTap callback and key.
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the accent color based on the product's category.
    final Color productColor = colorForCategory(product.category);

    // Determine the icon representing the product's category.
    final IconData productIcon = iconForCategory(product.category);

    // InkWell provides visual ripple feedback on tap when placed inside a Material/Ink widget.
    return InkWell(
      onTap: onTap, // Handles tap event to navigate to product details.
      borderRadius: BorderRadius.circular(16), // Ensures touch ripple respects rounded corners.
      child: Container(
        padding: const EdgeInsets.all(12), // Inner padding around all sides of card contents.
        decoration: BoxDecoration(
          color: Colors.white, // White card background.
          border: Border.all(
            color: Colors.grey.shade300, // Light grey outline border.
            width: 1.0, // 1 logical pixel border width.
          ),
          borderRadius: BorderRadius.circular(16), // Rounded outer card corners.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the left.
          children: [
            // Expanded widget ensures the category icon container fills available vertical space.
            Expanded(
              child: Container(
                width: double.infinity, // Stretch container across full width of card.
                decoration: BoxDecoration(
                  // Light tinted background using category accent color with 12% opacity.
                  color: productColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12), // Rounded corners for icon box.
                ),
                child: Center(
                  // Center the category icon inside its tinted container.
                  child: Icon(
                    productIcon, // Icon representing the category.
                    size: 38, // Icon visual size in logical pixels.
                    color: productColor, // Tint icon with category accent color.
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Vertical spacing between icon box and title.
            // Text widget displaying product name.
            Text(
              product.title, // Display product title.
              maxLines: 1, // Restrict title to single line.
              overflow: TextOverflow.ellipsis, // Append '...' if title exceeds available width.
              style: const TextStyle(
                fontSize: 16, // Font size for title.
                fontWeight: FontWeight.w600, // Medium-bold font weight.
                color: Colors.black87, // Dark slate text color.
              ),
            ),
            const SizedBox(height: 4), // Vertical spacing between title and price.
            // Text widget displaying product price with 1 decimal place.
            Text(
              '\$${product.price.toStringAsFixed(1)}', // Formats number as e.g. "$549.0".
              style: const TextStyle(
                fontSize: 16, // Font size for price.
                fontWeight: FontWeight.bold, // Bold emphasis for price.
                color: Colors.black, // High contrast black text color.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
