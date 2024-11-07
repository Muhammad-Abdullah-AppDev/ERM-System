import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scarlet_erm/components/custom_avatar.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/issue_invoice_note.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/receipt_invoice_note.dart';

class InventoryCreateVoucher extends StatefulWidget {
  @override
  _InventoryCreateVoucherState createState() => _InventoryCreateVoucherState();
}

class _InventoryCreateVoucherState extends State<InventoryCreateVoucher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.withOpacity(0.2),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.31,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Quick Actions',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomAvatar(
                              mainImagePath: 'assets/images/rating.png',
                              firstLabel: 'Receipt Note',
                              onPressed: () {
                                Get.to(
                                  ReceiptInvoiceNote(),
                                  transition: Transition.leftToRightWithFade,
                                );
                              },
                            ),
                            CustomAvatar(
                              mainImagePath: 'assets/images/coupon.png',
                              firstLabel: 'Issue Note',
                              onPressed: () {
                                Get.to(
                                  IssueInvoiceNote(),
                                  transition: Transition.leftToRightWithFade,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          child: const Text(
                            'List Detail',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            elevation: 7.0,
                            shadowColor: Colors.blue,
                            color: Colors.white,// Adjust elevation to match your design
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: GestureDetector(
                                // onTap: ,
                                child: const ListTile(
                                  leading: Icon(Icons.home,
                                      color: Colors.green), // Change the icon as needed
                                  title: Text(
                                    'Saved Vouchers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  subtitle:
                                  Text('Saved Vouchers of this Month',
                                    style: TextStyle(color: Colors.black),),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            elevation: 7.0,
                            shadowColor: Colors.blue,
                            color: Colors.white, // Adjust elevation to match your design
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: GestureDetector(
                                // onTap: ,
                                child: const ListTile(
                                  leading: Icon(Icons.receipt,
                                      color: Colors
                                          .green), // Change the icon as needed
                                  title: Text(
                                    'Verified Vouchers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  subtitle:
                                  Text("Verified Vouchers of this Month",
                                    style: TextStyle(color: Colors.black),),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: GestureDetector(
                      onTap: () {
                        // logic here
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 9,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(0.055),
                                radius: 30,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Image.asset(
                                          'assets/images/activity_icon.png',
                                          width: 39,
                                          height: 39,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            const Text(
                              'See all activity',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontFamily: 'one',
                                  color: Color(0xFF3366CC),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
