import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(body: Text(authProvider.user!.id));
  }
}
