import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/discount_progress_model.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:mi_ticket_desayuno_app/providers/discounts_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  String? _selectedDiscountId;
  int? _selectedDiscountValue;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    final discountsProvider = Provider.of<DiscountsProvider>(
      context,
      listen: false,
    );
    discountsProvider.getUserProgress();
  }

  void _selectDiscount(String discountId, int discountValue) {
    setState(() {
      if (_selectedDiscountId == discountId) {
        _selectedDiscountId = null;
        _selectedDiscountValue = null;
      } else {
        _selectedDiscountId = discountId;
        _selectedDiscountValue = discountValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final discountsProvider = Provider.of<DiscountsProvider>(context);
    final allDiscounts = discountsProvider.allDiscounts;

    final discounts =
        _filter == 'all'
            ? allDiscounts
            : allDiscounts.where((d) => d.type == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/icon.png'),
        title: const Text('Dashboard'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '¡Hola, ${authProvider.user.name}!',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
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
          _buildFilterChips(context),
          const SizedBox(height: 16),
          Column(
            key: ValueKey(_filter),
            children:
                discounts
                    .map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DiscountCard(
                          discount: d,
                          isSelected: _selectedDiscountId == d.id,
                          onSelect: () => _selectDiscount(d.id, d.discount),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'show-qr',
        onPressed:
            () => _showQrDialog(
              context,
              authProvider.user.id,

              _selectedDiscountValue ?? 0,
              _selectedDiscountId ?? "",
            ),
        icon: const Icon(Icons.qr_code),
        label: const Text('Mostrar QR'),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;
    ChoiceChip buildChip(String label, String value) {
      final selected = _filter == value;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: selectedColor.withAlpha(38),
        onSelected: (_) => setState(() => _filter = value),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        buildChip('Todos', 'all'),
        buildChip('Por gasto', 'spending'),
        buildChip('Por compras', 'purchases'),
      ],
    );
  }

  void _showQrDialog(
    BuildContext context,
    String userId,
    int discount,
    String discountId,
  ) async {
    try {
      final originalBrightness = await ScreenBrightness.instance.current;
      await ScreenBrightness.instance.setScreenBrightness(1.0);
      final qrData = jsonEncode({
        'user_id': userId,
        'discount': discount,
        'discount_id': discountId,
      });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => PopScope(
              canPop: false,
              child: AlertDialog(
                title: const Text('Tu código QR'),
                content: SizedBox(
                  height: 220,
                  width: 220,
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final discountsProvider = Provider.of<DiscountsProvider>(
                        context,
                        listen: false,
                      );
                      discountsProvider.getUserProgress();
                      context.pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
      );

      await ScreenBrightness.instance.setScreenBrightness(originalBrightness);
    } catch (e) {
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

class _DiscountCard extends StatelessWidget {
  const _DiscountCard({
    required this.discount,
    required this.isSelected,
    required this.onSelect,
  });

  final DiscountProgress discount;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final progress = discount.progress.toDouble();
    final icon = discount.type == 'spending' ? '💰' : '☕';
    final isComplete = progress >= 1.0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isComplete ? onSelect : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        discount.type == 'spending'
                            ? 'Por gasto'
                            : 'Por compras',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${discount.discount.toString()}%',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    discount.type == 'spending'
                        ? 'Gasta ${discount.value}€'
                        : 'Haz ${discount.value} compras',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isComplete
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 4),
                  Text('${(progress * 100).toStringAsFixed(0)} % completado'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
