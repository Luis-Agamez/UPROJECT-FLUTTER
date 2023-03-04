import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '../blocs/state/state_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.utc(0, 0, 0);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    late StateBloc stateBloc;
    stateBloc = BlocProvider.of<StateBloc>(context);
    void requestDay() {
      final date = _selectedDay
          .toString()
          .replaceRange(10, null, '')
          .replaceAll('-', ',');
      stateBloc.getResulstDate(date);
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await stateBloc.deleteAll();
            if (result) {
              var snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: '¡Completado!',
                  message: 'La informacion fue borrada',
                  contentType: ContentType.success,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              var snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: '¡Error!',
                  message: 'No se pudo completar la accion',
                  contentType: ContentType.failure,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Icon(Icons.delete),
        ),
        body: Column(
          children: [
            SafeArea(
              child: Column(
                children: [
                  TableCalendar(
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          requestDay(); // update `_focusedDay` here as well
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      focusedDay: _selectedDay,
                      firstDay: DateTime.utc(2018, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31)),
                  const SizedBox(height: 5),
                  const Text('Llenado',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const SizedBox(height: 5),
                  BlocBuilder<StateBloc, StateState>(
                    builder: (context, state) {
                      return state.successFlag
                          ? Column(
                              children: [
                                Container(
                                    child: state.dateResultsSuccess.isNotEmpty
                                        ? SizedBox(
                                            height: 120,
                                            child: SingleChildScrollView(
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: state
                                                    .dateResultsSuccess.length,
                                                itemBuilder: (context, index) {
                                                  final element =
                                                      state.dateResultsSuccess[
                                                          index];
                                                  return Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                    height: 90,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(element.messagge,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .green,
                                                                letterSpacing:
                                                                    1)),
                                                        Text(
                                                            element.date
                                                                .replaceAll(
                                                                    ',', '/'),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1)),
                                                        Text(
                                                            element.hour
                                                                .replaceAll(
                                                                    ',', ':'),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1))
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text('No hay Informacion'),
                                          ))
                              ],
                            )
                          : Center(
                              child: Lottie.network(
                                  'https://assets7.lottiefiles.com/packages/lf20_nrtm9xfr.json'));
                    },
                  ),
                  const SizedBox(height: 5),
                  const Text('Vacio',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const SizedBox(height: 5),
                  BlocBuilder<StateBloc, StateState>(
                    builder: (context, state) {
                      return state.alertsFlag
                          ? SizedBox(
                              height: 120,
                              child: SingleChildScrollView(
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: state.dateResultsAlerts.length,
                                  itemBuilder: (context, index) {
                                    final element =
                                        state.dateResultsAlerts[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      height: 90,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(element.messagge,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  letterSpacing: 1)),
                                          Text(
                                              element.date.replaceAll(',', '/'),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1)),
                                          Text(
                                              element.hour.replaceAll(',', ':'),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
