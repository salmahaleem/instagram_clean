part of 'single_real_cubit.dart';

sealed class SingleRealState extends Equatable {
  const SingleRealState();
}

final class SingleRealInitial extends SingleRealState {
  @override
  List<Object> get props => [];
}

class SingleRealLoading extends SingleRealState {
  @override
  List<Object> get props => [];
}


class SingleRealLoaded extends SingleRealState {
  final RealEntity real;

  const SingleRealLoaded({required this.real});
  @override
  List<Object> get props => [real];
}

class SingleRealFailure extends SingleRealState {
  @override
  List<Object> get props => [];
}
