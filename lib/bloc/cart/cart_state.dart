abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<String> cartItems; 

  CartLoaded(this.cartItems);
}