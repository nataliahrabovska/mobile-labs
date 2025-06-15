import 'package:equatable/equatable.dart';
import '../../../models/sensor_data.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SensorData> dataList;

  const HomeLoaded(this.dataList);

  @override
  List<Object?> get props => [dataList];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
