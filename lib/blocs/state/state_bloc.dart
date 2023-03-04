import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../global/environments.dart';
import '../../model/results_response.dart';
import 'package:http/http.dart' as http;

import '../../model/value.dart';

part 'state_event.dart';
part 'state_state.dart';

class StateBloc extends Bloc<StateEvent, StateState> {
  StateBloc() : super(StateState()) {
    on<StateEvent>((event, emit) {});

    on<SetAlerts>((event, emit) {
      emit(state.copyWith(isAlert: true, alerts: event.alerts));
    });
    on<SetSuccess>((event, emit) {
      emit(state.copyWith(isSuccess: true, success: event.success));
    });
    on<SetValue>((event, emit) {
      emit(state.copyWith(istanding: true, value: event.value));
    });
    on<SetFindAlerts>((event, emit) {
      emit(state.copyWith(
          alertsFlag: true, dateResultsAlerts: event.dateResultsAlerts));
    });
    on<SetFindSuccess>((event, emit) {
      emit(state.copyWith(
          successFlag: true, dateResultsSuccess: event.dateResultsSuccess));
    });
    on<SetLoading>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });
  }

  void getAlerts() async {
    final url = Uri.parse('${Enviroment.apiUrlBase}/find/alertall');
    final alerts =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (alerts.statusCode == 200) {
      final alertsResponse = ResultsResponse.fromJson(alerts.body);
      if (alertsResponse.results.isNotEmpty) {
        add(SetAlerts(alertsResponse.results));
      }
    }
  }

  void getSuccess() async {
    final url = Uri.parse('${Enviroment.apiUrlBase}/find/succesall');
    final succes =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (succes.statusCode == 200) {
      final alertsResponse = ResultsResponse.fromJson(succes.body);
      if (alertsResponse.results.isNotEmpty) {
        add(SetSuccess(alertsResponse.results));
      }
    }
  }

  void getValue() async {
    final url = Uri.parse('${Enviroment.apiUrlBase}/value');
    final succes =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (succes.statusCode == 200) {
      final valueResponse = ResultValue.fromJson(succes.body);
      print(valueResponse.value);
      add(SetValue(13 - valueResponse.value));
    }
  }

  void getResulstDate(String date) async {
    const SetLoading(true);
    final data = {'date': date};
    final urlA = Uri.parse('${Enviroment.apiUrlBase}/find/alert');
    final urlS = Uri.parse('${Enviroment.apiUrlBase}/find/succes');

    final succes = await http.post(urlS,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    final alerts = await http.post(urlA,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(succes.body.toString());
    print(alerts.body.toString());
    print(succes.statusCode);
    if (succes.statusCode == 200) {
      final successResponse = ResultsResponse.fromJson(succes.body);
      if (successResponse.results.isNotEmpty) {
        add(SetFindSuccess(successResponse.results));
      } else {}
    }

    if (alerts.statusCode == 200) {
      final alertsResponse = ResultsResponse.fromJson(alerts.body);
      if (alertsResponse.results.isNotEmpty) {
        add(SetFindAlerts(alertsResponse.results));
      } else {}
    }

    const SetLoading(false);
  }

  Future<bool> deleteAll() async {
    final urlSuccess = Uri.parse('${Enviroment.apiUrlBase}/delete/succes');
    final urlAlerts = Uri.parse('${Enviroment.apiUrlBase}/delete/alert');

    final succes = await http
        .get(urlSuccess, headers: {'Content-Type': 'application/json'});
    final alerts = await http
        .get(urlAlerts, headers: {'Content-Type': 'application/json'});

    if (alerts.statusCode == 200 && succes.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
