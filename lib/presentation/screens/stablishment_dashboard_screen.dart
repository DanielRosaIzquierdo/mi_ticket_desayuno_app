import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/discount_model.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StablishmentDashboardScreen extends StatelessWidget {
  const StablishmentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final discounts = [
      Discount(
        id: '1',
        type: 'spending',
        value: 50,
        conditions: 'Gasta 50 €',
        discount: 0.25,
      ),
      Discount(
        id: '2',
        type: 'purchases',
        value: 5,
        conditions: '5 visitas',
        discount: 0.5,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/icon.png'),
        title: const Text('Descuentos'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descuentos activos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Estos son los descuentos que has configurado.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: discounts.length,
                itemBuilder:
                    (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DiscountCard(discount: discounts[i]),
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-discount',
        onPressed: () => context.push('/add-discount'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo descuento'),
      ),
    );
  }
}

class _DiscountCard extends StatelessWidget {
  const _DiscountCard({required this.discount});

  final Discount discount;

  @override
  Widget build(BuildContext context) {
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
                const Spacer(),
                IconButton(
                  onPressed: () {
                    // Aquí se implementará la lógica de eliminar
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(discount.conditions),
            const SizedBox(height: 8),
            Text(
              'Descuento: ${(discount.discount * 100).toStringAsFixed(0)} %',
            ),
          ],
        ),
      ),
    );
  }
}
