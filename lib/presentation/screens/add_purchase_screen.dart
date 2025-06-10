import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/presentation/utils/utils.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mi_ticket_desayuno_app/providers/purchases_provider.dart';

class AddPurchaseScreen extends StatelessWidget {
  const AddPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final purchasesProvider = Provider.of<PurchasesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children:
                    purchasesProvider.products.map((product) {
                      final quantity = purchasesProvider.quantityOf(product);
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
                                        ? () =>
                                            purchasesProvider.decrement(product)
                                        : null,
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    () => purchasesProvider.increment(product),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            Text(
              'Total: ${purchasesProvider.total.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed:
                  purchasesProvider.isEmpty
                      ? null
                      : () async {
                        try {
                          dynamic result = await context.push('/qr-scanner');
                          if (result != null) {
                            Map<String, dynamic> resultMap = jsonDecode(result);
                            final String userId = resultMap["user_id"];
                            final int discount = resultMap["discount"];
                            final String discountId = resultMap["discount_id"];
                            final exists = await authProvider.checkUserExists(
                              userId,
                            );
                            if (exists) {
                              final purchase = purchasesProvider
                                  .createPurchaseObject(userId, discount);

                              await context.push(
                                '/purchase-summary',
                                extra: {
                                  'purchase': purchase,
                                  'discountId': discountId,
                                },
                              );
                            } else {
                              PresentationUtils.showCustomSnackbar(
                                context,
                                'Usuario no encontrado',
                              );
                            }
                          }
                        } catch (e) {
                          PresentationUtils.showCustomSnackbar(
                            context,
                            'Error al escanear, vuelve a intentarlo',
                          );
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
