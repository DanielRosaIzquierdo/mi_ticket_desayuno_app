import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mi_ticket_desayuno_app/presentation/utils/utils.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:mi_ticket_desayuno_app/providers/purchases_provider.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  @override
  void initState() {
    final purchasesProvider = Provider.of<PurchasesProvider>(
      context,
      listen: false,
    );
    purchasesProvider.getPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final purchasesProvider = Provider.of<PurchasesProvider>(context);

    final purchases = purchasesProvider.purchases;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        centerTitle: true,
        leading: Image.asset('assets/images/icon.png'),

        actions: [
        
          IconButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Confirmar eliminación'),
                      content: const Text(
                        '¿Estás seguro de que quieres borrar TODAS las compras? Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Borrar todo',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (confirmed == true) {
                final purchasesProvider = Provider.of<PurchasesProvider>(
                  context,
                  listen: false,
                );
                final success = await purchasesProvider.deleteAllPurchases();

                if (success) {
                  PresentationUtils.showCustomSnackbar(
                    context,
                    'Todas las compras han sido eliminadas',
                  );
                } else {
                  PresentationUtils.showCustomSnackbar(
                    context,
                    'Error al eliminar las compras',
                  );
                }
              }
            },
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Borrar todas las compras',
          ),
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
              child:
                  (purchases.isEmpty)
                      ? Center(child: Text('No hay compras aún'))
                      : ListView.builder(
                        itemCount: purchases.length,
                        itemBuilder: (_, index) {
                          final purchase = purchases[index];
                          final email =
                              purchase.userEmail ?? 'Usuario eliminado';
                            final formattedDate = DateFormat(
                            'dd MMM yyyy, HH:mm',
                            ).format(purchase.date.toLocal());

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
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Productos:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ...purchase.products.map(
                                    (p) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '- ${p.name}${p.quantity > 1 ? ' x${p.quantity}' : ''}',
                                        ),
                                        Text(
                                          '${(p.price * p.quantity).toStringAsFixed(2)} €',
                                        ),
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
        onPressed: () async => await context.push('/add-purchase'),
        icon: const Icon(Icons.add),
        label: const Text('Añadir compra'),
      ),
    );
  }
}
