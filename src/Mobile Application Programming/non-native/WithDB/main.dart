import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'trip_provider.dart';
import 'screens/home_screen.dart';
import 'screens/read_screen.dart';
import 'screens/create_screen.dart';
import 'screens/update_screen.dart';
import 'screens/delete_confirmation_screen.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://vbwfgnuijlbkejabvpfu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZid2ZnbnVpamxia2VqYWJ2cGZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ4ODYyNTcsImV4cCI6MjA1MDQ2MjI1N30.1z26P_lx5fRWvN1sSddJD1I8IfW2AhZZVRuCUtvoKS4',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => TripProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/read': (context) => ReadScreen(),
        '/create': (context) => CreateScreen(),
        '/update': (context) => UpdateScreen(),
        '/delete_confirm': (context) => DeleteConfirmationScreen(
            tripId: ModalRoute.of(context)?.settings.arguments as int),
      },
    );
  }
}
