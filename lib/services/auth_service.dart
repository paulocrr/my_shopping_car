import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_shopping_car/extensions/firebase_auth_extensions.dart';
import 'package:my_shopping_car/failures/failure.dart';
import 'package:my_shopping_car/failures/firebase_store_failure.dart';
import 'package:my_shopping_car/failures/google_sign_in_failure.dart';
import 'package:my_shopping_car/models/user.dart';

class AuthService {
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  Future<Either<Failure, User>> logInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credentials = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredentials =
          await firebaseAuth.signInWithCredential(credentials);

      final firebaseUser = userCredentials.user;

      if (firebaseUser != null) {
        final localUser = firebaseUser.toUser;

        final result = await firebaseStore
            .collection('users')
            .where('id', isEqualTo: localUser.id)
            .get();

        final documents = result.docs;

        if (documents.isEmpty) {
          await firebaseStore
              .collection('users')
              .doc(localUser.id)
              .set(localUser.toMap());
        }

        return Right(localUser);
      }

      return Left(GoogleSignInFailure());
    } on firebase_auth.FirebaseAuthException {
      return Left(GoogleSignInFailure());
    } on Exception {
      return Left(FirebaseStoreFailure());
    }
  }

  Stream<User?> get user {
    return firebaseAuth
        .authStateChanges()
        .map((firebaseUser) => firebaseUser?.toUser);
  }
}
