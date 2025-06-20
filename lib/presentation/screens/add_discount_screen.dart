import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/presentation/utils/utils.dart';
import 'package:mi_ticket_desayuno_app/providers/discounts_provider.dart';
import 'package:provider/provider.dart';

class AddDiscountScreen extends StatefulWidget {
  const AddDiscountScreen({super.key});

  @override
  State<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'spending';
  String _conditions = '';
  double _value = 0.0;
  double _discount = 0.0;

  void _submit() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      final discountsProvider = Provider.of<DiscountsProvider>(
        context,
        listen: false,
      );

      final discountId = await discountsProvider.addDiscount(
        type: _type,
        value: _value.toInt(),
        conditions: _conditions,
        discount: (_discount * 100).toInt(),
      );

      if (discountId != null) {
        if (mounted) {
          PresentationUtils.showCustomSnackbar(context, 'Descuento creado');
          discountsProvider.getDiscountsStablishmentView();
          context.pop();
        }
      } else {
        if (mounted) {
          PresentationUtils.showCustomSnackbar(
            context,
            'Error al crear descuento',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir descuento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'spending', child: Text('Por gasto')),
                  DropdownMenuItem(
                    value: 'purchases',
                    child: Text('Por compras'),
                  ),
                ],
                onChanged: (value) => setState(() => _type = value!),
                decoration: const InputDecoration(
                  labelText: 'Tipo de descuento',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Condiciones'),
                onSaved: (value) => _conditions = value ?? '',
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obligatorio'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      _type == 'spending'
                          ? 'Objetivo de gasto (€)'
                          : 'Objetivo de visitas',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _value = double.tryParse(value ?? '0')!,
                validator: (value) {
                  final v = double.tryParse(value ?? '');
                  if (v == null || v <= 0) {
                    return 'Debe ser mayor que 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descuento (%)'),
                keyboardType: TextInputType.number,
                onSaved:
                    (value) => _discount = double.tryParse(value ?? '0')! / 100,
                validator: (value) {
                  final v = double.tryParse(value ?? '');
                  if (v == null || v <= 0 || v > 100) {
                    return 'Debe estar entre 1 y 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Guardar descuento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
