import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/bank_balance_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/cash_balance_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_balance_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/party_balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/financial_pieChart.dart';

import '../../../../models/bank_balance_model.dart';
import '../../../../models/cash_balance_model.dart';
import '../../../../models/customer_balance_mode.dart';
import '../../../../models/party_balance_model.dart';
import '../../../../services/api_service.dart';

class FinanceScreen extends StatefulWidget {
  var custBal;
  var bankBal;
  var cashBal;
  var partyBal;

  FinanceScreen({
    required this.custBal,
    required this.bankBal,
    required this.cashBal,
    required this.partyBal,
    super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {

  bool isDrawerOpen = false;
  var custBal;
  var bankBal;
  var cashBal;
  var partyBal;

  Future<void> fetchDataAndPrintLength() async {
    try {
      var custBalance = ApiService.getCustomerBalance(
          "Balances/CustomerBalance");
      var bankBalance = ApiService.getBankBalance("Balances/BankBalance");
      var cashBalance = ApiService.getCashBalance("Balances/CashBalance");
      var partyBalance = ApiService.getPartyBalance("Balances/PartyBalance");

      List<CustomerBalanceModel> customerBalances = await custBalance;
      List<BankBalanceModel> bankBalances = await bankBalance;
      List<CashBalanceModel> cashBalances = await cashBalance;
      List<PartyBalanceModel> partyBalances = await partyBalance;

      debugPrint('Length is: ${customerBalances.length.toDouble()}');
      custBal = customerBalances.length.toDouble();
      debugPrint('Length is: ${bankBalances.length.toDouble()}');
      bankBal = bankBalances.length.toDouble();
      debugPrint('Length is: ${cashBalances.length.toDouble()}');
      cashBal = cashBalances.length.toDouble();
      debugPrint('Length is: ${partyBalances.length.toDouble()}');
      partyBal = partyBalances.length.toDouble();
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

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
                height: 280,
                width: MediaQuery.of(context).size.width * 1,
                decoration:
                    BoxDecoration(color: Colors.blueGrey.withOpacity(0.0001)),
                child: FinancialPieChart(
                  custBal: widget.custBal,
                  bankBal: widget.bankBal,
                  cashBal: widget.cashBal,
                  partyBal: widget.partyBal,
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildOption(
                  context,
                  Colors.lightBlue,
                  Icons.perm_contact_cal_outlined,
                  'Customer Balance',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CustomerBAlanceScreen())),
                ),
                buildOption(
                  context,
                  Colors.deepPurpleAccent,
                  Icons.account_balance,
                  'Bank Balance',
                  () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => BankBalance())),
                ),
                buildOption(
                  context,
                  Colors.blueGrey.shade700,
                  Icons.monetization_on_outlined,
                  'Cash Balance',
                  () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CashBalance())),
                ),
                buildOption(
                  context,
                  Colors.orangeAccent,
                  Icons.balance,
                  'Party Balance',
                  () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => PartyBalance())),
                ),
                SizedBox(height: 15,)
              ]),
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