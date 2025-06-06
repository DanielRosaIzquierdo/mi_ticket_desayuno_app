import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/presentation/screens/qr_scanner_screen.dart';
import 'package:provider/provider.dart';
import 'package:mi_ticket_desayuno_app/providers/purchases_provider.dart';

// Mantén la misma clase Product aquí (sin cambios)

// Mantén la clase Purchase sin cambios

class AddPurchaseScreen extends StatelessWidget {
  const AddPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PurchasesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children:
                    provider.products.map((product) {
                      final quantity = provider.quantityOf(product);
                      final selected = quantity > 0;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                selected
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        elevation: selected ? 8 : 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.imageAsset ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${product.price.toStringAsFixed(2)} €',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed:
                                    quantity > 0
                                        ? () => provider.decrement(product)
                                        : null,
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => provider.increment(product),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            // Muestra el total que viene del provider:
            Text(
              'Total: ${provider.total.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Botón QR (desplegar escáner y verificar usuario)
            ElevatedButton.icon(
              onPressed:
                  provider.isEmpty
                      ? null
                      : () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QRScannerScreen(),
                          ),
                        );

                        if (result != null) {
                          final userId = result.toString();

                          final exists = await provider.checkUserExists(userId);
                          if (exists) {
                            final purchase = provider.createPurchaseObject(
                              userId,
                            );
                            context.push('/purchase-summary', extra: purchase);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Usuario no encontrado'),
                              ),
                            );
                          }
                        }
                      },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Escanear QR usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
