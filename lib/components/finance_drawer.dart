import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Create%20Vouchers/journal_invoice.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Create%20Vouchers/payment_invoice.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Create%20Vouchers/receipt_invoice.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_balance_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_ledger.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/VoucherList/vc_screen_appBar.dart';

class FinanceDrawer extends StatefulWidget {
  const FinanceDrawer({
    Key? key,
    required this.voucher,
    required this.payment,
    required this.custBal,
    required this.custLedger,
  }) : super(key: key);

  final Color? voucher;
  final Color? payment;
  final Color? custBal;
  final Color? custLedger;

  @override
  _FinanceDrawerState createState() => _FinanceDrawerState();
}

class _FinanceDrawerState extends State<FinanceDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 140,
      shadowColor: const Color(0xff026ca6),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xff026ca6),
              thickness: 0.8,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  const VcScreenAppBar(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.voucher ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/voucher.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Voucher List',
                    style: TextStyle(
                      color: widget.voucher,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            buildDivider(),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  PaymentInvoice(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.payment ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/payment.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Payment',
                    style: TextStyle(
                      color: widget.payment,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            buildDivider(),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  ReceiptInvoice(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.payment ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/receipt.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Receipt',
                    style: TextStyle(
                      color: widget.payment,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            buildDivider(),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  JournalInvoice(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.payment ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/journal.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Journal',
                    style: TextStyle(
                      color: widget.payment,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            buildDivider(),
            const SizedBox(height: 5),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  CustomerBAlanceScreen(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.custBal ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/customer_bal.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Customer\n Balance',
                    style: TextStyle(
                      color: widget.custBal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            buildDivider(),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.to(
                  CustomerLedgerScreen(),
                  transition: Transition.leftToRightWithFade,
                );
              },
              child: Column(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      widget.custLedger ?? Colors.transparent,
                      BlendMode.srcIn,
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/customer_ledger.png"),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Text(
                    'Customer\n  ledger',
                    style: TextStyle(
                      color: widget.custLedger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      thickness: 1,
      color: Colors.blueAccent,
    );
  }
}
