import 'package:scarlet_erm/components/finance_drawer.dart';
import 'package:scarlet_erm/models/financial_voucher.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/finance_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/VoucherList/vc_screen.dart';
import 'package:scarlet_erm/services/api_service.dart';
import 'package:flutter/material.dart';

import 'Create Vouchers/create_voucher.dart';

class FinanceDashboard extends StatefulWidget {
  double custBal;
  double bankBal;
  double cashBal;
  double partyBal;

  FinanceDashboard({
    required this.custBal,
    required this.bankBal,
    required this.cashBal,
    required this.partyBal,
    super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Future<List<FinancialVoucher>> _dataFuture =
  ApiService().getFinancialVouchers("FinancialVoucher/GetFSVoucher");

  bool vcTabListener = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) {
      setState(() {
        vcTabListener = true;
      });
    } else {
      setState(() {
        vcTabListener = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const FinanceDrawer(
        voucher: Colors.grey,
        payment: Colors.grey,
        custBal: Colors.grey,
        custLedger: Colors.grey,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          vcTabListener ? 'Voucher List' : 'Finance Dashboard',
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
            Tab(text: 'Voucher List'),
            Tab(text: '+ Voucher'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FinanceScreen(
            custBal: widget.custBal,
            bankBal: widget.bankBal,
            cashBal: widget.cashBal,
            partyBal: widget.partyBal,
          ),
          VoucherScreen(dataFuture: _dataFuture),
          CreateVoucher(),
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
