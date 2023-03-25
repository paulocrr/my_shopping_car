import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:my_shopping_car/models/user.dart';

extension FirebaseAuthExtension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photoUrl: photoURL,
    );
  }
}
