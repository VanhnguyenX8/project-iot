part of 'product_bloc.dart';

abstract class ProductstEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductstFetched extends ProductstEvent {
  ProductstFetched();
}