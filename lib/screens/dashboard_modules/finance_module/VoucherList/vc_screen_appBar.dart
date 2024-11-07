import 'package:scarlet_erm/components/finance_drawer.dart';
import 'package:scarlet_erm/models/financial_voucher.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/VoucherList/vc_screen.dart';
import 'package:scarlet_erm/services/api_service.dart';
import 'package:flutter/material.dart';

class VcScreenAppBar extends StatefulWidget {
  const VcScreenAppBar({super.key});

  @override
  State<VcScreenAppBar> createState() => _VcScreenAppBarState();
}

class _VcScreenAppBarState extends State<VcScreenAppBar> {

  final Future<List<FinancialVoucher>> _dataFuture =
  ApiService().getFinancialVouchers("FinancialVoucher/GetFSVoucher");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.blueGrey.shade50
        : Colors.black45,
      endDrawer: FinanceDrawer(voucher: Color(0xff026ca6), payment: Colors.grey,
        custBal: Colors.grey, custLedger: Colors.grey,),
      appBar: AppBar(
        title: Text('Vouchers'),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: VoucherScreen(dataFuture: _dataFuture),
    );
  }
  Widget buildDivider(Color? color) {
    return Divider(
      thickness: 1,
      color: color,
    );
  }
}
