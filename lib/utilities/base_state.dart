import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_shopping_car/failures/failure.dart';

abstract class BaseState extends Equatable {
  final Option<Failure> failure;
  final bool isLoading;

  const BaseState({
    required this.failure,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [failure, isLoading];
}
