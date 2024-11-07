import 'dart:async';

import 'package:scarlet_erm/components/text_widget.dart';
import 'package:scarlet_erm/models/bank_balance_model.dart';
import 'package:scarlet_erm/models/cash_balance_model.dart';
import 'package:scarlet_erm/models/customer_balance_mode.dart';
import 'package:scarlet_erm/models/party_balance_model.dart';
import 'package:scarlet_erm/screens/auth/login_screen.dart';
import 'package:scarlet_erm/screens/dashboard_modules/about_us.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/finance_dashboard.dart';
import 'package:scarlet_erm/screens/dashboard_modules/inventory_module/inventory_dashboard.dart';
import 'package:scarlet_erm/screens/dashboard_modules/sales_module/sales_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scarlet_erm/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDrawerIndex = -1;

  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    setState(() {});
  }

  String? name;
  bool isDrawerOpen = false;

  var custBal;
  var bankBal;
  var cashBal;
  var partyBal;

  @override
  void initState() {
    name = GetStorage().read("usid");
    super.initState();

    fetchDataAndPrintLength();
  }

  Future<void> fetchDataAndPrintLength() async {
    try {
      // Call the API service and assign the returned future to custBalance
      var custBalance = ApiService.getCustomerBalance("Balances/CustomerBalance");
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

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer

    // Navigate based on the selected index
    switch (index) {
      case 0:
        if (custBal == null || bankBal == null || cashBal == null || partyBal == null) {
          Timer(const Duration(seconds: 2), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FinanceDashboard(
                    custBal: custBal,
                    bankBal: bankBal,
                    cashBal: cashBal,
                    partyBal: partyBal)));
          });
        } else {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => FinanceDashboard(
          custBal: custBal,
          bankBal: bankBal,
          cashBal: cashBal,
          partyBal: partyBal)));
        }
        break;

      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => InventoryDashboard()));
        break;

      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SalesDashboard()));
        break;

      case 3:
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => InventoryScreen()));
        break;

      case 4:
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => InventoryScreen()));
        break;

      case 5:
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => InventoryScreen()));
        break;

      case 6:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AboutUs()));
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    var drawerItems = [
      {'icon': 'assets/images/finance.png', 'text': 'Finance'},
      {'icon': 'assets/images/inventory.png', 'text': 'Inventory'},
      {'icon': 'assets/images/sales.png', 'text': 'Sales'},
      {'icon': 'assets/images/hr2.png', 'text': 'HR'},
      {'icon': 'assets/images/payroll.png', 'text': 'Payroll'},
      {'icon': 'assets/images/crm.png', 'text': 'CRM'},
      {'icon': 'assets/images/about.png', 'text': 'About'},
    ];

    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        InkWell(
          onTap: () => _onSelectItem(i),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 12.0), // Adjust the padding as needed
            child: Column(
              children: <Widget>[
                Image.asset(
                  d['icon']!,
                  width: 42,
                  height: 42,
                ),
                const SizedBox(height: 8),
                Text(d['text']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
        ),
      );
      drawerOptions.add(Divider(
        thickness: 1.5,
        color: Colors.blueGrey.shade200,
      ));
    }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.35,
          backgroundColor: Colors.white,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              children: [
                SizedBox(
                  height: AppBar().preferredSize.height,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xff026ca6),
                  thickness: 0.5,
                ),
                Expanded(
                  child: Center(
                    child: ListView(
                      children: drawerOptions,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 5,
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Future.value(theme == ThemeMode.dark);
                setState(() {
                  switchTheme();
                });
              },
              icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.sunny
                      : Icons.brightness_2_outlined,
                  color: Colors.white,
                  size: 25),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                color: Theme.of(context).colorScheme.primary),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: Center(
                              child: Image.asset(
                                'assets/images/profile.png',
                                height: 55,
                                width: 65,
                              ),
                            )),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () async {
                                GetStorage().remove('email');
                                GetStorage().remove('password');
                                GetStorage().remove('usid');
                                _box.remove('email');
                                _box.remove('password');

                                Navigator.pop(context);
                                await Future.delayed(const Duration(milliseconds: 1));
                                Get.offAll(() => const LoginScreen(),
                                    transition: Transition.leftToRightWithFade);
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              )),
                        )
                      ],
                    ),
                  ),
                  MyTextWidget(
                    text: "   ${name ?? ""}",
                    size: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      children: <Widget>[
                        _buildGridItem(
                          label: 'Finance',
                          onTap: () {
                            if (custBal == null || bankBal == null || cashBal == null || partyBal == null) {
                              Timer(const Duration(seconds: 1), () {
                                if (custBal == null || bankBal == null || cashBal == null || partyBal == null) {
                                  custBal = 0.0;
                                  bankBal = 0.0;
                                  cashBal = 0.0;
                                  partyBal = 0.0;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => FinanceDashboard(
                                          custBal: custBal,
                                          bankBal: bankBal,
                                          cashBal: cashBal,
                                          partyBal: partyBal)));
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => FinanceDashboard(
                                          custBal: custBal,
                                          bankBal: bankBal,
                                          cashBal: cashBal,
                                          partyBal: partyBal)));
                                }
                              });
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => FinanceDashboard(
                                      custBal: custBal,
                                      bankBal: bankBal,
                                      cashBal: cashBal,
                                      partyBal: partyBal)));
                            }
                          },
                          imagePath: 'assets/images/budget.png',
                        ),
                        _buildGridItem(
                          label: 'Inventory',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InventoryDashboard()),
                            );
                          },
                          imagePath: 'assets/images/inventory.png',
                        ),
                        _buildGridItem(
                          label: 'Sales',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SalesDashboard()),
                            );
                          },
                          imagePath: 'assets/images/sales.png',
                        ),
                        _buildGridItem(
                          label: 'HR',
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => newDashBorad()),
                            // );
                          },
                          imagePath: 'assets/images/hr.png',
                        ),
                        _buildGridItem(
                          label: 'Payroll',
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => newDashBorad()),
                            // );
                          },
                          imagePath: 'assets/images/proll.png',
                        ),
                        _buildGridItem(
                          label: 'CRM',
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => newDashBorad()),
                            // );
                          },
                          imagePath: 'assets/images/crm.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildGridItem(
    {required String label,
    required VoidCallback onTap,
    IconData? icon,
    String? imagePath}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        // Existing Container for Grid Item
        Container(
          width: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.indigo.shade50,
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(3.0, 3.0),
                blurRadius: 3.0,
                spreadRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imagePath != null)
                Image.asset(imagePath, height: 50.0, width: 50.0)
              else if (icon != null)
                Icon(icon, size: 50.0, color: Colors.white),
              const SizedBox(height: 8.0),
              Text(label,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 20)),
            ],
          ),
        ),
        // Line at the bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 4, // Adjust the height of the line as needed
            decoration: const BoxDecoration(
              color: Colors.blue, // Color of the line
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}