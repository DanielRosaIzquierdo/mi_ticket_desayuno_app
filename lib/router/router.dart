import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/client_dashboard_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/client_qr_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/login_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/register_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: '/client-dashboard',
      builder: (context, state) => ClientDashboardScreen(),
    ),
    GoRoute(path: '/client-qr', builder: (context, state) => ClientQrScreen()),
  ],
);
