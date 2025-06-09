import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool checkLoginResult = await authProvider.checkLogin();
    if (checkLoginResult) {
      if (authProvider.user.role == 'client') {
        context.pushReplacement('/client-dashboard');
      } else if (authProvider.user.role == 'stablishment') {
        context.pushReplacement('/stablishment-dashboard');
      }
      return;
    }

    context.pushReplacement('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
