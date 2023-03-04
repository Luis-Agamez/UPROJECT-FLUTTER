part of 'state_bloc.dart';

abstract class StateEvent extends Equatable {
  const StateEvent();

  @override
  List<Object> get props => [];
}

class SetValue extends StateEvent {
  final int value;
  const SetValue(this.value);
}

class SetLoading extends StateEvent {
  final bool loading;
  const SetLoading(this.loading);
}

class SetAlerts extends StateEvent {
  final List<Result> alerts;
  const SetAlerts(this.alerts);
}

class SetSuccess extends StateEvent {
  final List<Result> success;
  const SetSuccess(this.success);
}

class SetFindSuccess extends StateEvent {
  final List<Result>? dateResultsSuccess;
  const SetFindSuccess(this.dateResultsSuccess);
}

class SetFindAlerts extends StateEvent {
  final List<Result>? dateResultsAlerts;

  const SetFindAlerts(this.dateResultsAlerts);
}
