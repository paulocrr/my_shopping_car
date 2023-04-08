import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/models/product.dart';
import 'package:my_shopping_car/services/products_service.dart';
import 'package:my_shopping_car/utilities/base_state.dart';

class ProductDetailsBloc extends Cubit<ProductDetailsState> {
  final productsService = ProductsService();

  ProductDetailsBloc() : super(const ProductDetailsState());

  void getProductDetail(String id) async {
    _emitLoading();

    final either = await productsService.getProductDetails(id: id);

    either.fold((f) {
      emit(ProductDetailsState(failure: Some(f)));
    }, (r) {
      emit(ProductDetailsState(product: r));
    });
  }

  void _emitLoading() =>
      const ProductDetailsState(isLoading: true, failure: None());
}

class ProductDetailsState extends BaseState {
  final Product? product;

  const ProductDetailsState({
    super.failure = const None(),
    super.isLoading = false,
    this.product,
  });

  ProductDetailsState copyWith({
    Option<Failure>? failure,
    bool? isLoading,
    Product? product,
  }) {
    return ProductDetailsState(
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [...super.props, product];
}
