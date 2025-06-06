import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/add_discount_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/add_purchase_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/client_dashboard_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/login_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/purchase_summary_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/purchases_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/qr_scanner_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/register_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/splash_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/stablishment_dashboard_screen.dart';
import 'package:mi_ticket_desayuno_app/presentation/shell/navigation_shell.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(
      path: '/add-discount',
      builder: (context, state) => AddDiscountScreen(),
    ),
    GoRoute(
      path: '/client-dashboard',
      builder: (context, state) => ClientDashboardScreen(),
    ),
    GoRoute(
      path: '/add-purchase',
      builder: (context, state) => AddPurchaseScreen(),
    ),
    // En tu configuración de rutas (normalmente en main.dart o router.dart):
    GoRoute(
      path: '/qr-scanner',
      builder: (context, state) => const QRScannerScreen(),
    ),
    GoRoute(
      path: '/purchase-summary',
      builder: (context, state) {
        final purchase = state.extra as Purchase;
        return PurchaseSummaryScreen(purchase: purchase);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              NavigationShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stablishment-dashboard',
              pageBuilder:
                  (context, state) => const NoTransitionPage(
                    child: StablishmentDashboardScreen(),
                  ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/purchases',
              pageBuilder:
                  (context, state) =>
                      const NoTransitionPage(child: PurchasesScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
