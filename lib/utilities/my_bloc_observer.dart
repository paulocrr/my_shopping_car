import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

class MyBlocObserver extends BlocObserver {
  final logger = Logger();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.i('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    logger.i('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    logger.e('onError == ${bloc.runtimeType}, $error, $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    logger.i('onClose -- ${bloc.runtimeType}');
  }
}
