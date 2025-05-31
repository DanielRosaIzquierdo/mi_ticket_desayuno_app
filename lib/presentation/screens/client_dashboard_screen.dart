import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/discount_model.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart'; // ← usamos qr_flutter

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  /// Filtros posibles: 'all', 'spending', 'purchases'
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // ─────────── Datos de ejemplo ───────────
    final allDiscounts = <Discount>[
      Discount(
        id: '1',
        type: 'spending',
        value: 0.35,
        conditions: 'Gasta 50 €',
      ),
      Discount(
        id: '2',
        type: 'purchases',
        value: 0.60,
        conditions: '10 visitas',
      ),
      Discount(
        id: '3',
        type: 'spending',
        value: 0.10,
        conditions: 'Primer café',
      ),
    ];
    final discounts =
        _filter == 'all'
            ? allDiscounts
            : allDiscounts.where((d) => d.type == _filter).toList();
    // ────────────────────────────────────────

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/icon.png'),
        title: Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authProvider.logout();
              context.pushReplacement('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      // ═════════════════ BODY ═════════════════
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ► Saludo
          Text(
            '¡Hola, ${authProvider.user.name}!',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // ► Título + descripción
          const Text(
            'Descuentos disponibles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Revisa tu progreso y aprovecha las promociones de tu cafetería favorita.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // ► Filtros
          _buildFilterChips(context),
          const SizedBox(height: 16),

          // ► Lista animada con bounce-in
          Column(
            key: ValueKey(_filter),
            children:
                discounts
                    .map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DiscountCard(discount: d),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),

      // ═════════ FAB QR ═════════
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQrDialog(context, authProvider.user.id),
        icon: const Icon(Icons.qr_code),
        label: const Text('Mostrar QR'),
      ),
    );
  }

  // ─────────── Chips de filtro ───────────
  Widget _buildFilterChips(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;

    ChoiceChip buildChip(String label, String value) {
      final selected = _filter == value;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: selectedColor.withValues(alpha: 0.15),
        onSelected: (_) => setState(() => _filter = value),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        buildChip('Todos', 'all'),
        buildChip('Por gasto', 'spending'),
        buildChip('Por visitas', 'purchases'),
      ],
    );
  }

  // ─────────── Dialog con QR usando qr_flutter ───────────

  void _showQrDialog(BuildContext context, String userId) async {
    try {
      // Guarda el brillo actual
      final originalBrightness = await ScreenBrightness.instance.application;

      // Sube el brillo al máximo para mostrar el QR
      await ScreenBrightness.instance.setApplicationScreenBrightness(1.0);

      // Muestra el diálogo con el QR
      await showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Tu código QR'),
              content: SizedBox(
                height: 220,
                width: 220,
                child: QrImageView(
                  data: userId,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
      );

      // Restaura el brillo original
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        originalBrightness,
      );
    } catch (e) {
      debugPrint('Error al ajustar el brillo: $e');
      showDialog(
        context: context,
        builder:
            (_) => const AlertDialog(
              title: Text('Error'),
              content: Text('No se pudo cambiar el brillo de la pantalla.'),
            ),
      );
    }
  }
}

// ─────────── Card de descuento ───────────
class _DiscountCard extends StatelessWidget {
  const _DiscountCard({required this.discount});

  final Discount discount;

  @override
  Widget build(BuildContext context) {
    final progress = discount.value.toDouble();
    final icon = discount.type == 'spending' ? '💰' : '☕';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  discount.type == 'spending' ? 'Por gasto' : 'Por visitas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              discount.conditions,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 4),
            Text('${(progress * 100).toStringAsFixed(0)} % completado'),
          ],
        ),
      ),
    );
  }
}
