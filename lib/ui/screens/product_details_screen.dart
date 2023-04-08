import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_shopping_car/blocs/product_cart.bloc.dart';
import 'package:my_shopping_car/blocs/product_details_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  const ProductDetailsScreen({super.key, required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProductDetailsBloc>().getProductDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del producto'),
      ),
      body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          final product = state.product;
          if (product != null) {
            return ListView(
              children: [
                if (product.image != null && product.image!.isNotEmpty)
                  Image.network(product.image!),
                Text(product.name),
                Text(product.price.toStringAsFixed(2)),
                if (product.brand != null && product.brand!.isNotEmpty)
                  Text(product.brand!),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductCarBloc>().addProduct(product);
                    Navigator.pop(context);
                  },
                  child: Text('Agregar al carrito'),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
