part of "cart_bloc.dart";

abstract class CartEvent {}

// Add an item to the cart
class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  AddToCart(this.product, this.quantity);
}

// Remove or decrease an item from the cart
class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

// Clear the cart completely
class ClearCart extends CartEvent {}