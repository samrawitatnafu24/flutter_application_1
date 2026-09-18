abstract class CartEvent {}

// Add an item to the cart
class AddToCart extends CartEvent {
  final String productId;
  AddToCart(this.productId);
}

// Remove or decrease an item from the cart
class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

// Clear the cart completely
class ClearCart extends CartEvent {}