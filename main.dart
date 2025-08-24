import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/time_entry_provider.dart';
import 'provider/project_task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()..loadEntries()),
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider()..loadProjectsTasks()),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}