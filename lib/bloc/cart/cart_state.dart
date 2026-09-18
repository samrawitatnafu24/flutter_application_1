part of "cart_bloc.dart";

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems; 

  CartLoaded(this.cartItems);

  int get itemCount {
    int count=0;

    for (var item in cartItems) {
      count += item.quantity;
    }

    return count;
  }
}