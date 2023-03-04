import 'package:flutter/material.dart';
import 'package:proyecto/screens/calendar_screen.dart';
import 'package:proyecto/screens/details_screen.dart';
import 'package:proyecto/screens/home_screen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'home': (_) => const HomeScreen(),
  'details': (_) => const DetailsScreen(),
  'calendar': (_) => const CalendarScreen(),
};
