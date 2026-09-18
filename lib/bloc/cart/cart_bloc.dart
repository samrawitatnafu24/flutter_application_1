import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<String> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    
    // Add to cart
    on<AddToCart>((event, emit) {
      _cartItems.add(event.productId);
      emit(CartLoaded(List.from(_cartItems)));
    });

    // Remove from cart
    on<RemoveFromCart>((event, emit) {
      _cartItems.remove(event.productId);
      emit(CartLoaded(List.from(_cartItems)));
    });

    // Clear cart
    on<ClearCart>((event, emit) {
      _cartItems.clear();
      emit(CartLoaded(List.from(_cartItems)));
    });
  }
}