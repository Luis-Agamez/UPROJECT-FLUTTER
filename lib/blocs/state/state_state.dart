part of 'state_bloc.dart';

class StateState extends Equatable {
  final bool istanding;
  final bool loading;
  final int value;
  final bool isAlert;
  final bool successFlag;
  final bool alertsFlag;
  final bool isSuccess;
  final List<Result> alerts;
  final List<Result> success;
  final List<Result> dateResultsSuccess;
  final List<Result> dateResultsAlerts;

  const StateState(
      {this.value = 0,
      this.alertsFlag = false,
      this.loading = false,
      this.successFlag = false,
      this.istanding = false,
      this.isAlert = false,
      this.isSuccess = false,
      this.alerts = const [],
      this.success = const [],
      this.dateResultsSuccess = const [],
      this.dateResultsAlerts = const []});

  StateState copyWith({
    bool? istanding,
    bool? loading,
    int? value,
    bool? isAlert,
    bool? isSuccess,
    bool? successFlag,
    bool? alertsFlag,
    List<Result>? alerts,
    List<Result>? success,
    List<Result>? dateResultsSuccess,
    List<Result>? dateResultsAlerts,
  }) =>
      StateState(
        value: value ?? this.value,
        istanding: istanding ?? this.istanding,
        loading: loading ?? this.loading,
        isAlert: isAlert ?? this.isAlert,
        alertsFlag: alertsFlag ?? this.alertsFlag,
        successFlag: successFlag ?? this.successFlag,
        isSuccess: isSuccess ?? this.isSuccess,
        alerts: alerts ?? this.alerts,
        success: success ?? this.success,
        dateResultsAlerts: dateResultsAlerts ?? this.dateResultsAlerts,
        dateResultsSuccess: dateResultsSuccess ?? this.dateResultsSuccess,
      );

  @override
  List<Object> get props => [
        value,
        istanding,
        loading,
        isAlert,
        isSuccess,
        alerts,
        success,
        successFlag,
        alertsFlag,
        dateResultsAlerts,
        dateResultsSuccess
      ];
}
