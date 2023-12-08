import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/model/product.dart';
import 'package:notifications/respositories/products_respository.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductsBloc extends Bloc<ProductstEvent, ProductsState> {
  ProductsBloc(this.productRespository) : super(const ProductsState()) {
    on<ProductstFetched>(_onProductsFetched);
  }
  ProductRespository productRespository;
  CancelToken? _productFetchedToken;

  Future<void> _onProductsFetched(ProductstFetched event, Emitter<ProductsState> emit) async {
    try {
      _productFetchedToken?.cancel();
      _productFetchedToken = CancelToken();
      emit(state.copyWith(status: ProductsStatus.loading, error: null));
      final data = await productRespository.getProducts(cancelToken: _productFetchedToken);
      return emit(state.copyWith(status: ProductsStatus.success, products: data, error: null));
    } catch (error) {
      _productFetchedToken?.cancel();
      emit(state.copyWith(status: ProductsStatus.failure, error: error.toString()));
    } finally {
      _productFetchedToken = null;
    }
  }

  @override
  Future<void> close() {
    _productFetchedToken?.cancel();
    return super.close();
  }
}