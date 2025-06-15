import 'package:equatable/equatable.dart';

abstract class SavedQrState extends Equatable {
  const SavedQrState();

  @override
  List<Object?> get props => [];
}

class SavedQrLoading extends SavedQrState {}

class SavedQrLoaded extends SavedQrState {
  final String message;
  const SavedQrLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

class SavedQrError extends SavedQrState {
  final String error;
  const SavedQrError(this.error);

  @override
  List<Object?> get props => [error];
}
