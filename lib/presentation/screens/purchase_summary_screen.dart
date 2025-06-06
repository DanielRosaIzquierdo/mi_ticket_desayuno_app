import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/models/purchase_model.dart';

class PurchaseSummaryScreen extends StatelessWidget {
  final Purchase purchase;

  const PurchaseSummaryScreen({Key? key, required this.purchase})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumen Compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Usuario: ${purchase.userId}'),
            Text('Fecha: ${purchase.date.toLocal()}'),
            Expanded(
              child: ListView.builder(
                itemCount: purchase.products.length,
                itemBuilder: (context, index) {
                  final p = purchase.products[index];
                  return ListTile(
                    title: Text(p.name),
                    trailing: Text('${p.price.toStringAsFixed(2)} €'),
                  );
                },
              ),
            ),
            Text(
              'Total: ${purchase.totalAmount.toStringAsFixed(2)} €',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
