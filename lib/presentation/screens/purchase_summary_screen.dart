import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';
import 'package:intl/intl.dart';
import 'package:mi_ticket_desayuno_app/providers/purchases_provider.dart';
import 'package:provider/provider.dart';

class PurchaseSummaryScreen extends StatelessWidget {
  final Purchase purchase;

  const PurchaseSummaryScreen({Key? key, required this.purchase})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final purchasesProvider = Provider.of<PurchasesProvider>(context);

    final Map<String, List<double>> grouped = {};
    for (var p in purchase.products) {
      grouped.putIfAbsent(p.name, () => []).add(p.price);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usuario ID: ${purchase.userId}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(purchase.date.toLocal())}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Productos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children:
                    grouped.entries.map((entry) {
                      final name = entry.key;
                      final prices = entry.value;
                      final quantity = prices.length;
                      final unitPrice = prices.first;
                      final totalPrice = prices.reduce((a, b) => a + b);
                      return Card(
                        child: ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle:
                              quantity > 1
                                  ? Text(
                                    'x$quantity • ${unitPrice.toStringAsFixed(2)} € c/u',
                                  )
                                  : null,
                          trailing: Text(
                            '${totalPrice.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Aquí puedes agregar la lógica más adelante
                    purchasesProvider.resetSelectedProducts();
                    context.go('/purchases');
                  },
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28,),
                  label: const Text(
                    'Finalizar compra',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // color más llamativo
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                Text(
                  'Total: ${purchase.totalAmount.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
