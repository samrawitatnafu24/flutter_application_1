abstract class ProductEvent {}

class GetProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final String product;

  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final int index;
  final String product;

  UpdateProduct(this.index, this.product);
}

class DeleteProduct extends ProductEvent {
  final int index;

  DeleteProduct(this.index);
}
