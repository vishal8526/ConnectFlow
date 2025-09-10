import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_admin.dart';
import 'screens/dashboard/dashboard_employee.dart';
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ConnectFlowApp());
}

class ConnectFlowApp extends StatelessWidget {
  const ConnectFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
      ],
      child: MaterialApp(
        title: 'ConnectFlow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const LoginScreen(),
        routes: {
          '/employee': (_) => const DashboardEmployee(),
          '/admin': (_) => const DashboardAdmin(),
        },
      ),
    );
  }
}
