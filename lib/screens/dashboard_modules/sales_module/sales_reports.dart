import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scarlet_erm/screens/dashboard_modules/sales_module/sales_BarChart.dart';

import '../../../models/get_account_no_dialog.dart';
import '../../../models/list_details_model.dart';
import '../../../models/response_data_model.dart';
import '../../../services/api_service.dart';

class SalesReport extends StatefulWidget {

  SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {

  bool isDrawerOpen = false;
  var custBal;
  var bankBal;
  var cashBal;
  var partyBal;

  // Future<void> fetchDataAndPrintLength() async {
  //   try {
  //     // Call the API service and assign the returned future to custBalance
  //     var custBalance = ApiService.getCustomerBalance(
  //         "Balances/CustomerBalance");
  //     var bankBalance = ApiService.getBankBalance("Balances/BankBalance");
  //     var cashBalance = ApiService.getCashBalance("Balances/CashBalance");
  //     var partyBalance = ApiService.getPartyBalance("Balances/PartyBalance");
  //
  //     List<CustomerBalanceModel> customerBalances = await custBalance;
  //     List<BankBalanceModel> bankBalances = await bankBalance;
  //     List<CashBalanceModel> cashBalances = await cashBalance;
  //     List<PartyBalanceModel> partyBalances = await partyBalance;
  //
  //     debugPrint('Length is: ${customerBalances.length.toDouble()}');
  //     custBal = customerBalances.length.toDouble();
  //     debugPrint('Length is: ${bankBalances.length.toDouble()}');
  //     bankBal = bankBalances.length.toDouble();
  //     debugPrint('Length is: ${cashBalances.length.toDouble()}');
  //     cashBal = cashBalances.length.toDouble();
  //     debugPrint('Length is: ${partyBalances.length.toDouble()}');
  //     partyBal = partyBalances.length.toDouble();
  //   } catch (e) {
  //     debugPrint('Error fetching data: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      body: SafeArea(
        child: buildFinanceContent(context),
      ),
    );
  }

  Widget buildFinanceContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                decoration:
                BoxDecoration(color: Colors.blueGrey.withOpacity(0.0001)),
                child: SalesBarChart()
              ),
              // Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              //   buildOption(
              //     context,
              //     const Color(0xff4b87b9),
              //     Icons.perm_contact_cal_outlined,
              //     'Customer Balance',
              //         () => Navigator.push(context,
              //         MaterialPageRoute(builder: (_) => CustomerBAlanceScreen())),
              //   ),
              //   buildOption(
              //     context,
              //     const Color(0xffc06c84),
              //     Icons.account_balance,
              //     'Bank Balance',
              //         () => Navigator.push(
              //         context, MaterialPageRoute(builder: (_) => BankBalance())),
              //   ),
              //   buildOption(
              //     context,
              //     Color(0xfff67280),
              //     Icons.monetization_on_outlined,
              //     'Cash Balance',
              //         () => Navigator.push(
              //         context, MaterialPageRoute(builder: (_) => CashBalance())),
              //   ),
              //   buildOption(
              //     context,
              //     const Color(0xfff6b095),
              //     Icons.balance,
              //     'Party Balance',
              //         () => Navigator.push(
              //         context, MaterialPageRoute(builder: (_) => PartyBalance())),
              //   ),
              //   SizedBox(height: 15,)
              // ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOption(BuildContext context, Color color, IconData icon,
      String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 1.5, blurRadius: 2),
                ],
              ),
            ),
            Center(
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.82,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 20),
                      Text(
                        text,
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
