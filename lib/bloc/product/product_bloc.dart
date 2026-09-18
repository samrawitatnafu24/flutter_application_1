import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<String> products = [
    'iPhone',
    'Samsung',
    'Laptop',
    'Headphones',
  ];

  ProductBloc() : super(ProductInitial()) {
    on<GetProducts>(_getProducts);
    on<AddProduct>(_addProduct);
    on<UpdateProduct>(_updateProduct);
    on<DeleteProduct>(_deleteProduct);
  }

  void _getProducts(
    GetProducts event,
    Emitter<ProductState> emit,
  ) {
    emit(ProductLoaded(List.from(products)));
  }

  void _addProduct(
    AddProduct event,
    Emitter<ProductState> emit,
  ) {
    products.add(event.product);

    emit(ProductLoaded(List.from(products)));
  }

  void _updateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) {
    products[event.index] = event.product;

    emit(ProductLoaded(List.from(products)));
  }

  void _deleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) {
    products.removeAt(event.index);

    emit(ProductLoaded(List.from(products)));
  }
}
