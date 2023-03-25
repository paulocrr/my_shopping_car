import 'package:my_shopping_car/failures/failure.dart';

class FirebaseStoreFailure extends Failure {
  FirebaseStoreFailure() : super(message: 'No se pudo guardar la data');
}
