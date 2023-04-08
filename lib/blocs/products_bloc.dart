import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/models/product.dart';
import 'package:my_shopping_car/services/products_service.dart';
import 'package:my_shopping_car/utilities/base_state.dart';

class ProductsBloc extends Cubit<ProductsState> {
  final productsService = ProductsService();

  ProductsBloc() : super(const ProductsState());

  void getProducts() async {
    _emitLoading();

    final either = await productsService.getProducts();

    either.fold((f) {
      emit(ProductsState(failure: Some(f)));
    }, (r) {
      emit(ProductsState(products: r));
    });
  }

  void _emitLoading() => const ProductsState(isLoading: true, failure: None());
}

class ProductsState extends BaseState {
  final CollectionReference<Product>? products;

  const ProductsState({
    super.failure = const None(),
    super.isLoading = false,
    this.products,
  });

  ProductsState copyWith({
    Option<Failure>? failure,
    bool? isLoading,
    CollectionReference<Product>? products,
  }) {
    return ProductsState(
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [...super.props, products];
}
