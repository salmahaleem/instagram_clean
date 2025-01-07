part of 'real_cubit.dart';

sealed class RealState extends Equatable {
  const RealState();
}

final class RealInitial extends RealState {
  @override
  List<Object> get props => [];
}

class RealLoading extends RealState {
  @override
  List<Object> get props => [];
}

class RealLoaded extends RealState {
  final List<RealEntity> reals;

  RealLoaded({required this.reals});
  @override
  List<Object> get props => [reals];
}

class RealSuccess extends RealState {
  final RealEntity real;

  RealSuccess({required this.real});
  @override
  List<Object> get props => [real];
}

class RealFailure extends RealState {
  @override
  List<Object> get props => [];
}

