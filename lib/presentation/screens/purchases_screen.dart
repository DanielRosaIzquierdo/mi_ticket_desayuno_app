import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final mockUserEmails = {
      'user1': 'ana@example.com',
      'user2': 'luis@example.com',
    };

    final purchases = [
      Purchase(
        id: 'p1',
        userId: 'user1',
        totalAmount: 18.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        products: [
          Product(name: 'Café', price: 1.50),
          Product(name: 'Croissant', price: 2.00),
          Product(name: 'Zumo', price: 3.00),
        ],
      ),
      Purchase(
        id: 'p2',
        userId: 'user2',
        totalAmount: 12.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        products: [
          Product(name: 'Tostada', price: 2.00),
          Product(name: 'Té', price: 1.50),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de compras'),
        centerTitle: true,
        leading: Image.asset('assets/images/icon.png'),

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
              'Historial de compras',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Revisa todas las compras realizadas en tu establecimiento.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: purchases.length,
                itemBuilder: (_, index) {
                  final purchase = purchases[index];
                  final email =
                      mockUserEmails[purchase.userId] ?? 'Usuario desconocido';
                  final formattedDate = DateFormat(
                    'dd MMM yyyy, HH:mm',
                  ).format(purchase.date);

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt_long, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  email,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '${purchase.totalAmount.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fecha: $formattedDate',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Productos:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ...purchase.products.map(
                            (p) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('- ${p.name}'),
                                Text('${p.price.toStringAsFixed(2)} €'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-purchase',
        onPressed: () => context.push('/add-purchase'),
        icon: const Icon(Icons.add),
        label: const Text('Añadir compra'),
      ),
    );
  }
}
