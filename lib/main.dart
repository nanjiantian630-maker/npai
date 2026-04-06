import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const NiubiAIApp());
}

class NiubiAIApp extends StatelessWidget {
  const NiubiAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '牛批AI',
      debugShowCheckedModeBanner: false,
      theme: NiubiTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainShell(),
      },
    );
  }
}
