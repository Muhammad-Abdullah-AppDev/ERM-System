import 'package:scarlet_erm/models/inventory_vcList_model.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/inventory_create_vc.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/inventory_reports.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/inventory_vcList.dart';
import 'package:scarlet_erm/services/api_service.dart';
import 'package:flutter/material.dart';

class InventoryDashboard extends StatefulWidget {

  InventoryDashboard({super.key});

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Future<List<InventoryVcListModel>> _dataFutureSales =
  ApiService().getInventoryVouchers("GRNGoodsReceiptNote/GetVoucherList");
  bool isDrawerOpen = false;
  bool vcTabListener = false;
  bool vcTabListener2 = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _dataFutureSales;
  }

  void _handleTabSelection() {
    if (_tabController.index == 1 || _tabController.index == 2) {
      if(_tabController.index == 1) {
        setState(() {
          vcTabListener = true;
        });
      } else {
        setState(() {
          vcTabListener2 = true;
          vcTabListener = false;
        });
      }
    } else {
      setState(() {
        vcTabListener = false;
        vcTabListener2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: const FinanceDrawer(
      //   voucher: Colors.grey,
      //   payment: Colors.grey,
      //   custBal: Colors.grey,
      //   custLedger: Colors.grey,
      // ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          vcTabListener ? 'Vouchers List' : vcTabListener2 ? 'Inventory Invoice' : 'Inventory DashBoard',
          style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 10,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
          splashFactory: NoSplash.splashFactory,
          tabs: const [
            Tab(text: 'Reports'),
            Tab(text: 'Invoice List'),
            Tab(text: '+ Invoice'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InventoryReport(),
          InventoryVoucherScreen(dataFutureSales: _dataFutureSales),
          InventoryCreateVoucher(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}