part of 'product_bloc.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({this.status = ProductsStatus.initial, this.products = const [], this.error});

  final ProductsStatus status;
  final List<Product> products;
  final String? error;

  ProductsState copyWith({ProductsStatus? status, List<Product>? products, String? error}) {
    return ProductsState(status: status ?? this.status, products: products ?? this.products, error: error ?? this.error);
  }

  @override
  String toString() {
    return '''BooskState { status: $status, Product: $products, error: $error }''';
  }

  @override
  List<Object?> get props => [status, products, error];
}