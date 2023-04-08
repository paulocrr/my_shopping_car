import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/models/product.dart';
import 'package:my_shopping_car/utilities/base_state.dart';

class ProductCarBloc extends Cubit<ProductCarState> {
  ProductCarBloc() : super(const ProductCarState());

  void addProduct(Product product) {
    final currentList = List<Product>.from(state.productList);
    currentList.add(product);
    emit(ProductCarState(productList: currentList));
  }
}

class ProductCarState extends BaseState {
  final List<Product> productList;

  int get numberOfProducts {
    return productList.length;
  }

  const ProductCarState({
    super.failure = const None(),
    super.isLoading = false,
    this.productList = const [],
  });

  ProductCarState copyWith({
    List<Product>? productList,
    Option<Failure>? failure,
    bool? isLoading,
  }) {
    return ProductCarState(
      failure: failure ?? this.failure,
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [productList];
}
