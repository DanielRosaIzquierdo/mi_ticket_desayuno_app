import 'package:flutter/material.dart';
import 'package:mi_ticket_desayuno_app/models/top_spenders_model.dart';
import 'package:mi_ticket_desayuno_app/providers/purchases_provider.dart';
import 'package:provider/provider.dart';
import 'package:mi_ticket_desayuno_app/models/top_purchasers_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;

  final List<Tab> _tabs = const [
    Tab(text: 'Top gastos'),
    Tab(text: 'Top compras'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    Future.microtask(() async {
      final provider = context.read<PurchasesProvider>();
      await provider.getTopSpenders();
      await provider.getTopPurchasers();
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSpendersList(List<TopSpender> data) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos disponibles.'));
    }
    return RefreshIndicator(
       onRefresh: () async {
          final provider = context.read<PurchasesProvider>();
          await provider.getTopSpenders();
          await provider.getTopPurchasers();
        },
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(item.email),
            trailing: Text(
              '${item.totalSpent.toStringAsFixed(2)} €',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPurchasersList(List<TopPurchaser> data) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos disponibles.'));
    }
    return RefreshIndicator(
       onRefresh: () async {
          final provider = context.read<PurchasesProvider>();
          await provider.getTopSpenders();
          await provider.getTopPurchasers();
        },
      child: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(item.email),
            trailing: Text(
              '${item.purchaseCount} compras',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchasesProvider = context.watch<PurchasesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
        leading: Image.asset('assets/images/icon.png'),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSpendersList(purchasesProvider.topSpenders),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPurchasersList(purchasesProvider.topPurchasers),
          ),
        ],
      ),
    );
  }
}
