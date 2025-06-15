import 'package:equatable/equatable.dart';

abstract class QrScannerState extends Equatable {
  const QrScannerState();

  @override
  List<Object?> get props => [];
}

class QrScannerInitial extends QrScannerState {
  final String log;

  const QrScannerInitial({this.log = '🟢 Ready for the test'});

  @override
  List<Object?> get props => [log];
}

class QrScannerLogUpdated extends QrScannerState {
  final String log;

  const QrScannerLogUpdated(this.log);

  @override
  List<Object?> get props => [log];
}
