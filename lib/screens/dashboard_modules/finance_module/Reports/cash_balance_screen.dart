import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scarlet_erm/components/finance_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scarlet_erm/models/cash_balance_model.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_balance_screen.dart';
import 'package:scarlet_erm/services/api_service.dart';

class CashBalance extends StatefulWidget {
  @override
  _CashBalanceState createState() => _CashBalanceState();
}

class _CashBalanceState extends State<CashBalance> {

  String? usid;
  bool loading = true;
  bool isSearchVisible = false;
  double? _totalBalance = 0;

  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CashBalanceModel>? cashBalanceList;
  List<CashBalanceModel>? filteredList;

  @override
  void initState() {
    usid = GetStorage().read('usid');
    debugPrint("KKKKKKKKKKKKKKKKKKK$usid");
    super.initState();
    getBankBalanceData();
  }

  Future<void> getBankBalanceData() async {
    setState(() {
      loading = true;
    });

    cashBalanceList = await ApiService.getCashBalance(
        'Balances/CashBalance');
    filteredList = List<CashBalanceModel>.from(cashBalanceList!);
    _totalBalance = cashBalanceList!
        .fold(0, (sum, customer) => sum! + (customer.bAL ?? 0));
// Sort the list by customer name
    sortList();
    setState(() {
      loading = false;
    });
  }

  void sortList() {
    filteredList!
        .sort((a, b) => a.nAME!.toLowerCase().compareTo(b.nAME!.toLowerCase()));
  }

  void searchCustomer(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List<CashBalanceModel>.from(cashBalanceList!);
      } else {
        filteredList = cashBalanceList!
            .where((element) =>
            element.nAME!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTotalAmount =
    NumberFormat("#,##0.##", "en_US").format(_totalBalance);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black87,
      endDrawer: FinanceDrawer(
        voucher: Colors.grey,
        payment: Colors.grey,
        custBal: Colors.grey,
        custLedger: Colors.grey,
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Cash Balance"),
        elevation: 0,
        actions: <Widget>[
          AnimatedSearchIconButton(
            isSearchVisible: isSearchVisible,
            onSearchIconPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
            onSearch: searchCustomer,
          ),
          IconButton(
            icon: const Icon(Icons.menu), // You can change this icon as needed
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Open the end drawer
            },
          ),
        ],
      ),
      body: loading
          ? Center(
        child: SpinKitRipple(
          color: Color(0xFF144b9d),
          size: 160,
          borderWidth: 10,
        ),
      )
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: AnimatedSearchBar(
                  isSearchVisible: isSearchVisible,
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  searchCustomer: searchCustomer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 5),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue.shade400,
                        Colors.indigo.shade400,
                      ],
                    ),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(
                          7.0,
                          7.0,
                        ),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      ),
                    ], //BoxShadow
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receivable:',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Text(
                        '$formattedTotalAmount',
                        style: const TextStyle(
                            fontSize: 22, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              if (filteredList!.isEmpty) ...[
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Center(child: Text('No data found')),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredList!.length,
                    separatorBuilder: (context, index) =>
                    const Divider(color: Colors.transparent),
                    itemBuilder: (context, index) {
                      var formateAmount = NumberFormat("#,##0.##", "en_US")
                          .format(double.parse(
                          filteredList![index].bAL.toString()));
                      CashBalanceModel selectedCustomer =
                      filteredList![index];
                      return Card(
                        child: ListTile(
                          tileColor: index.isEven
                              ? Colors.blueGrey[50]
                              : Colors.blue[50],
                          title: Text('${filteredList![index].nAME}',
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                          trailing: Text('$formateAmount',
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 15,),
            ],
          ),
    );
  }
}