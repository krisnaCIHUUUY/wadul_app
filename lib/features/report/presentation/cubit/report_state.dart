
import 'package:equatable/equatable.dart';
import 'package:wadul_app/features/report/domain/entities/report_entity.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final String message;
  const ReportSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ReportFailure extends ReportState {
  final String message;
  const ReportFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ReportLoaded extends ReportState {
  final List<ReportEntity> reports;
  const ReportLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

class ReportDetailLoaded extends ReportState {
  final ReportEntity report;
  const ReportDetailLoaded(this.report);

  @override
  List<Object> get props => [report];
}
