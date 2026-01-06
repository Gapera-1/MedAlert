import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/medicine_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/app_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MedicineProvider>(
          create: (_) => MedicineProvider(),
          update: (_, auth, previous) => previous ?? MedicineProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MedAlert',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const AuthWrapper(),
          '/app': (context) => const AppScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.isAuthenticated) {
      return const AppScreen();
    } else {
      return const AuthScreen();
    }
  }
}

