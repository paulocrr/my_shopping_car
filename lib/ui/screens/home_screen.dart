import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shopping_car/blocs/product_cart.bloc.dart';
import 'package:my_shopping_car/blocs/product_details_bloc.dart';
import 'package:my_shopping_car/blocs/products_bloc.dart';
import 'package:my_shopping_car/models/product.dart';
import 'package:my_shopping_car/ui/navigation/shopping_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mi tienda'),
            BlocBuilder<ProductCarBloc, ProductCarState>(builder: (_, state) {
              return Text('Productos: ${state.productList.length}');
            }),
          ],
        ),
        // actions: <Widget>[
        //   // BlocBuilder<ProductCarBloc, ProductCarState>(builder: (_, state) {
        //   //   return Text('${state.numberOfProducts}');
        //   // }),
        //   TextButton(onPressed: () {}, child: Text('Save'))
        // ],
      ),
      body: BlocProvider<ProductsBloc>(
        create: (context) => context.read<ProductsBloc>()..getProducts(),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            final products = state.products;

            if (products != null) {
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<ProductsBloc>()..getProducts(),
                child: FirestoreListView<Product>(
                  query: products,
                  pageSize: 10,
                  itemBuilder: (_, doc) {
                    final product = doc.data();

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('S/ ${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        context.goNamed(
                          ShoppingRoutesNames.productDetailsName,
                          params: {
                            ShoppingRoutesParams.productId: product.id,
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
