import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_ticket_desayuno_app/models/discount_stablishment_view.dart';
import 'package:mi_ticket_desayuno_app/presentation/utils/utils.dart';
import 'package:mi_ticket_desayuno_app/providers/auth_provider.dart';
import 'package:mi_ticket_desayuno_app/providers/discounts_provider.dart';
import 'package:provider/provider.dart';

class StablishmentDashboardScreen extends StatefulWidget {
  const StablishmentDashboardScreen({super.key});

  @override
  State<StablishmentDashboardScreen> createState() =>
      _StablishmentDashboardScreenState();
}

class _StablishmentDashboardScreenState
    extends State<StablishmentDashboardScreen> {
  late Future<bool> _discountsFuture;

  @override
  void initState() {
    super.initState();
    _discountsFuture =
        context.read<DiscountsProvider>().getDiscountsStablishmentView();
  }

  @override
  Widget build(BuildContext context) {
    final discountsProvider = context.watch<DiscountsProvider>();
    final authProvider =
        context.read<AuthProvider>(); 

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

      body: FutureBuilder<bool>(
        future: _discountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == false) {
            return const Center(
              child: Text('No se pudieron cargar los descuentos.'),
            );
          }

          return _buildDiscountsList(context, discountsProvider);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-discount',
        onPressed: () => context.push('/add-discount'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo descuento'),
      ),
    );
  }

  Widget _buildDiscountsList(BuildContext context, DiscountsProvider provider) {
    final discounts = provider.discountsStablishmentView;

    if (discounts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _discountsFuture = provider.getDiscountsStablishmentView();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: const Center(
              child: Text(
                'Aún no has creado ningún descuento.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _discountsFuture = provider.getDiscountsStablishmentView();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
    );
  }
}

class _DiscountCard extends StatelessWidget {
  const _DiscountCard({required this.discount});

  final DiscountStablishmentView discount;

  @override
  Widget build(BuildContext context) {
    final icon = discount.type == 'spending' ? '💰' : '☕';
    final provider = context.read<DiscountsProvider>();

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
                  discount.type == 'spending' ? 'Por gasto' : 'Por compras',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed:
                      () => _showDeleteConfirmationDialog(context, provider),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
            const SizedBox(height: 8),
            Text('Descuento: ${(discount.discount).toStringAsFixed(0)} %'),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    DiscountsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar este descuento? Esta acción no se puede deshacer.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                context.pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () async {
                final success = await provider.deleteDiscount(discount.id);

                context.pop();

                if (context.mounted) {
                  PresentationUtils.showCustomSnackbar(
                    context,
                    success
                        ? 'Descuento eliminado correctamente'
                        : 'Error al eliminar el descuento',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
