import 'package:flutter_application_1/data/market_store.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/models/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {


  CartBloc() : super(CartInitial()) {
    
    // Add to cart
    on<AddToCart>((event, emit) {
      MarketStore.addToCart(event.product, event.quantity);

      emit(CartLoaded(List.from(MarketStore.cart)));
    });

    // Remove from cart
    on<RemoveFromCart>((event, emit) {
      MarketStore.removeFromCart(event.productId);
     
      emit(CartLoaded(List.from(MarketStore.cart)));
    });

    // Clear cart
    on<ClearCart>((event, emit) {
      MarketStore.clearCart();
      
      emit(CartLoaded(List.from(MarketStore.cart)));
    });
  }
}