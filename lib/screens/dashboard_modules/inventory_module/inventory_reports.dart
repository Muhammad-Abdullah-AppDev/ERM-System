import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InventoryReport extends StatefulWidget {

  InventoryReport({super.key});

  @override
  State<InventoryReport> createState() => _InventoryReportState();
}

class _InventoryReportState extends State<InventoryReport> {

  bool isDrawerOpen = false;
  var custBal;
  var bankBal;
  var cashBal;
  var partyBal;

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
                  //child: SalesBarChart()
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
