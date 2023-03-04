import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:proyecto/screens/calendar_screen.dart';

import '../blocs/state/state_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _screens = const [
    SafeArea(
      child: _PrincipalScreen(),
    ),
    CalendarScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            //  showSelectedLabels: false,
            iconSize: 28,
            elevation: 8,
            currentIndex: _selectedIndex,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            selectedItemColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_sharp),
                label: 'Calendar',
              ),
            ]),
        body: _screens[_selectedIndex]);
  }
}

class _PrincipalScreen extends StatefulWidget {
  const _PrincipalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<_PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<_PrincipalScreen> {
  late StateBloc stateBloc;
  int minutes = 0;
  @override
  void initState() {
    stateBloc = BlocProvider.of<StateBloc>(context);
    stateBloc.getAlerts();
    stateBloc.getSuccess();
    stateBloc.getValue();
    timer();
    super.initState();
  }

  void timer() {
    Timer.periodic(const Duration(minutes: 1), ((timer) {
      if (mounted) {
        setState(() {
          minutes++;
        });
      }
    }));
  }

  @override
  void dispose() {
    timer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
        GlobalKey<LiquidPullToRefreshState>();
    Future<void> _handleRefresh() async {
      //TODO

      stateBloc.getAlerts();
      stateBloc.getSuccess();
      stateBloc.getValue();
      setState(() {
        minutes = 0;
      });
      return await Future.delayed(Duration(milliseconds: 300));
    }

    final dateNow = DateTime.now()
        .toString()
        .replaceRange(16, null, '')
        .replaceAll('-', '/');
    return LiquidPullToRefresh(
      springAnimationDurationInMilliseconds: 500,
      key: _refreshIndicatorKey,
      color: Colors.blue,
      backgroundColor: Colors.blue,
      height: 400,
      borderWidth: 40,
      onRefresh: _handleRefresh,
      showChildOpacityTransition: true,
      child: ListView(
        children: [
          Center(
              child: Column(
            children: [
              Container(
                height: 320,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.blueGrey]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120),
                        bottomRight: Radius.circular(120))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: BlocBuilder<StateBloc, StateState>(
                    builder: (context, state) {
                      double percentage = (state.value / 13) * 100;
                      return state.istanding
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Aqua Inteligents',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2)),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Bienvenido',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2)),
                                    Text(dateNow,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2)),
                                    const Icon(
                                      Icons.water_drop,
                                      size: 25,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Estado Actual',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text('${percentage.toInt()}%',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 90)),
                                  ],
                                )
                              ],
                            )
                          : Container();
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ultima Lectura :',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1),
                                  ),
                                  Text(
                                    'Hace $minutes minutos',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        letterSpacing: 1),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              child: BlocBuilder<StateBloc, StateState>(
                                builder: (context, state) {
                                  return state.istanding
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Altura del Agua:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              '${state.value} cm',
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                            )
                          ],
                        ))),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: BlocBuilder<StateBloc, StateState>(
                            builder: (context, state) {
                              return state.isAlert && state.isSuccess
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Ultimo Llenado :',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              state
                                                  .success[
                                                      state.success.length - 1]
                                                  .date
                                                  .replaceAll(',', '/'),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              state
                                                  .success[
                                                      state.success.length - 1]
                                                  .hour
                                                  .replaceAll(',', ':'),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Ultima vez vacio',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              state
                                                  .success[
                                                      state.success.length - 1]
                                                  .date
                                                  .replaceAll(',', '/'),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              state
                                                  .alerts[
                                                      state.alerts.length - 1]
                                                  .hour
                                                  .replaceAll(',', ':'),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              'Tiempo promedio de llenado ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              '8:00 min',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              'Desbordamientos en los ultimos dias ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  letterSpacing: 1),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  : Container();
                            },
                          ),
                        ))),
              )
            ],
          )),
        ],
      ),
    );
  }
}

class Chronometers {}
