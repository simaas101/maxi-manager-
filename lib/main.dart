import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';
import 'screens/login_screen.dart';
import 'screens/users_screen.dart';

void main() {
  runApp(const MikroTikApp());
}

class MikroTikApp extends StatelessWidget {
  const MikroTikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MaterialApp(
        title: 'MikroTik Manager',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/users': (_) => const UsersScreen(),
        },
      ),
    );
  }
}
