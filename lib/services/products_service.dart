import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/failures/firebase_store_failure.dart';
import 'package:my_shopping_car/failures/products_get_failure.dart';
import 'package:my_shopping_car/models/product.dart';

class ProductsService {
  final firebaseFirestore = FirebaseFirestore.instance;

  Future<Either<Failure, CollectionReference<Product>>> getProducts() async {
    try {
      return Right(
        firebaseFirestore.collection('products').withConverter(
              fromFirestore: (snapshot, _) => Product.fromFirestore(snapshot),
              toFirestore: (product, _) => product.toMap(),
            ),
      );
    } catch (e) {
      return Left(ProductsGetFailure());
    }
  }

  Future<Either<Failure, Product>> getProductDetails(
      {required String id}) async {
    try {
      final document =
          await firebaseFirestore.collection('products').doc(id).get();
      return Right(Product.fromFirestore(document));
    } catch (e) {
      return Left(FirebaseStoreFailure());
    }
  }
}
