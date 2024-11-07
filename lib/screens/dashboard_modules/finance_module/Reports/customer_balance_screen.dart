import 'package:scarlet_erm/components/finance_drawer.dart';
import 'package:scarlet_erm/models/customer_balance_mode.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_details.dart';
import 'package:scarlet_erm/screens/dashboard_modules/finance_module/Reports/customer_ledger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../services/api_service.dart';

// ignore: must_be_immutable
class CustomerBAlanceScreen extends StatefulWidget {
  CustomerBAlanceScreen({super.key});

  @override
  State<CustomerBAlanceScreen> createState() => _CustomerBAlanceScreenState();
}

class _CustomerBAlanceScreenState extends State<CustomerBAlanceScreen> {
  double? _totalBalance = 0;
  final _searchFocusNode = FocusNode();
  bool loading = true;
  String? usid;
  bool isSearchVisible = false;

  List<CustomerBalanceModel>? customerBalanceList;
  List<CustomerBalanceModel>? filteredList;
  final _searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDrawerOpen = false;

  @override
  void initState() {
    usid = GetStorage().read('usid');
    debugPrint("KKKKKKKKKKKKKKKKKKK$usid");
    getData();

    super.initState();
  }

  //getapi method
  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    customerBalanceList =
        await ApiService.getCustomerBalance('Balances/CustomerBalance');
    filteredList = List<CustomerBalanceModel>.from(customerBalanceList!);
    _totalBalance = customerBalanceList!
        .fold(0, (sum, customer) => sum! + (customer.balance ?? 0));
// Sort the list by customer name
    sortList();
    setState(() {
      loading = false;
    });
  }

  // Sort the filtered list by customer name
  void sortList() {
    filteredList!
        .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
  }

  // filteredData method
  void searchCustomer(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List<CustomerBalanceModel>.from(customerBalanceList!);
      } else {
        filteredList = customerBalanceList!
            .where((element) =>
                element.name!.toLowerCase().contains(query.toLowerCase()))
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
        custBal: Color(0xFF144b9d),
        custLedger: Colors.grey,
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Customer Balance"),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                  child: AnimatedSearchBar(
                    isSearchVisible: isSearchVisible,
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    searchCustomer: searchCustomer,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
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
                SizedBox(height: 10),
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
                                filteredList![index].balance.toString()));
                        CustomerBalanceModel selectedCustomer =
                            filteredList![index];
                        return Slidable(
                            startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const DrawerMotion(),
                              children: [
                              SlidableAction(
                                onPressed: (context){
                                  debugPrint("On Action Swipe clicked called");
                                  Get.to(CustomerDetailsScreen(
                                    selectedCustomerName: selectedCustomer.name,
                                    selectedCustomerId: selectedCustomer.pkcode,
                                    selectedCustomerBal: selectedCustomer.balance,
                                  ),
                                    transition: Transition.leftToRightWithFade,
                                  );
                                },
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.arrow_forward,
                                label: 'Customer DTL',
                                spacing: 6,
                                autoClose: true,
                              ),
                            ],), // Set the threshold here
                          child: InkWell(
                            onTap: () {
                              //_searchController.clear();
                              Get.to(
                                CustomerLedgerScreen(
                                  selectedCustomerName: selectedCustomer.name,
                                  selectedCustomerId: selectedCustomer.pkcode,
                                ),
                                transition: Transition.leftToRightWithFade,
                              );
                            },
                            child: Card(
                              child: ListTile(
                                tileColor: index.isEven ? Colors.blueGrey[50] : Colors.blue[50],
                                title: Text('${filteredList![index].name}',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                                trailing: Text('$formateAmount', style: TextStyle(fontSize: 14, color: Colors.black)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 10),
              ],
            ),
    );
  }
}

class AnimatedSearchIconButton extends StatelessWidget {
  final bool isSearchVisible;
  final VoidCallback onSearchIconPressed;
  final Function(String) onSearch;

  AnimatedSearchIconButton({
    required this.isSearchVisible,
    required this.onSearchIconPressed,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: isSearchVisible
          ? IconButton(
              key: ValueKey<bool>(isSearchVisible),
              icon: const Icon(Icons.close),
              onPressed: onSearchIconPressed,
            )
          : IconButton(
              key: ValueKey<bool>(isSearchVisible),
              icon: const Icon(Icons.search),
              onPressed: onSearchIconPressed,
            ),
    );
  }
}

class AnimatedSearchBar extends StatelessWidget {
  final bool isSearchVisible;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) searchCustomer;

  AnimatedSearchBar({
    required this.isSearchVisible,
    required this.searchController,
    required this.searchFocusNode,
    required this.searchCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isSearchVisible ? 56 : 0,
      width: isSearchVisible ? MediaQuery.of(context).size.width - 40 : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: searchController,
          focusNode: searchFocusNode,
          onChanged: searchCustomer,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            prefixIcon: isSearchVisible ? Icon(Icons.search) : null,
            isDense: true,
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isSearchVisible
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isSearchVisible
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                  width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            hintText: 'Search Customers...',
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

// SizedBox balanceListCard(context, String? title, String? Qty, Color color,
//     {Callback? ontap}) {
//   return SizedBox(
//     width: double.infinity,
//     child: Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: InkWell(
//             onTap: ontap,
//             child: Card(
//               color: color,
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.bottomLeft,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Text(
//                       '$title',
//                       overflow: TextOverflow.visible,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Theme.of(context).colorScheme.onPrimary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Card(
//             color: color,
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Text(
//                     '$Qty',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Theme.of(context).colorScheme.onPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

Widget buildDivider() {
  return Divider(
    thickness: 1,
    color: Colors.blueAccent,
  );
}

// import 'package:Scarlet_erm/components/finance_drawer.dart';
// import 'package:Scarlet_erm/models/customer_balance_mode.dart';
// import 'package:Scarlet_erm/screens/dashboard_modules/finance_module/customer_ledger.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import '../../../services/api_service.dart';
//
// // ignore: must_be_immutable
// class CustomerBAlanceScreen extends StatefulWidget {
//   CustomerBAlanceScreen({super.key});
//
//   @override
//   State<CustomerBAlanceScreen> createState() => _CustomerBAlanceScreenState();
// }
//
// class _CustomerBAlanceScreenState extends State<CustomerBAlanceScreen> {
//   double? _totalBalance = 0;
//   final _searchFocusNode = FocusNode();
//   bool loading = true;
//   String? usid;
//
//   List<CustomerBalanceModel>? customerBalanceList;
//   List<CustomerBalanceModel>? filteredList;
//   final _searchController = TextEditingController();
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   bool isDrawerOpen = false;
//   bool isSearchVisible = false;
//
//   @override
//   void initState() {
//     usid = GetStorage().read('usid');
//     debugPrint("KKKKKKKKKKKKKKKKKKK$usid");
//     getData();
//
//     super.initState();
//   }
//
//   //getapi method
//   Future<void> getData() async {
//     setState(() {
//       loading = true;
//     });
//
//     customerBalanceList = await ApiService.getCustomerBalance(
//         'CustomerBal/GetBalance?usid=$usid');
//     filteredList = List<CustomerBalanceModel>.from(customerBalanceList!);
//     _totalBalance = customerBalanceList!
//         .fold(0, (sum, customer) => sum! + (customer.balance ?? 0));
// // Sort the list by customer name
//     sortList();
//     setState(() {
//       loading = false;
//     });
//   }
//
//   // Sort the filtered list by customer name
//   void sortList() {
//     filteredList!
//         .sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
//   }
//
//   // filteredData method
//   void searchCustomer(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredList = List<CustomerBalanceModel>.from(customerBalanceList!);
//       } else {
//         filteredList = customerBalanceList!
//             .where((element) =>
//                 element.name!.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTotalAmount =
//         NumberFormat("#,##0.##", "en_US").format(_totalBalance);
//
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//         ? Colors.white
//         : Colors.black87,
//       endDrawer: FinanceDrawer(
//         voucher: Colors.grey,
//         payment: Colors.grey,
//         custBal: Color(0xFF144b9d),
//         custLedger: Colors.grey,
//       ),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF144b9d),
//         foregroundColor: Colors.white,
//         title: Text("Customer Balance"),
//         elevation: 0,
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.menu), // You can change this icon as needed
//             onPressed: () {
//               _scaffoldKey.currentState?.openEndDrawer(); // Open the end drawer
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           loading
//               ? Center(
//                   child: SpinKitRipple(
//                     color: Color(0xFF144b9d),
//                     size: 160,
//                     borderWidth: 10,)
//                 )
//               : Column(
//                   children: [
//                     SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: TextFormField(
//                         controller: _searchController,
//                         focusNode: _searchFocusNode,
//                         onChanged: searchCustomer,
//                         textInputAction: TextInputAction.done,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.search),
//                           isDense: true,
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.error),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.error),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(15.0)),
//                           ),
//                           disabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.primary),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 width: 2.0),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).colorScheme.primary,
//                                 width: 2.0),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(15.0)),
//                           ),
//                           hintText: 'Search Customers...',
//                           hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.light
//                                     ? Colors.grey[600]
//                                     : Colors.white),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
//                       child: Container(
//                         width: double.infinity,
//                         height: MediaQuery.of(context).size.height * 0.15,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topRight,
//                             end: Alignment.bottomLeft,
//                             colors: [
//                               Colors.blue.shade400,
//                               Colors.indigo.shade400,
//                             ],
//                           ),
//                           boxShadow:[
//                             const BoxShadow(
//                               color: Colors.grey,
//                               offset: Offset(
//                                 7.0,
//                                 7.0,
//                               ),
//                               blurRadius: 8.0,
//                               spreadRadius: 2.0,
//                             ),
//                           ],//BoxShadow
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.all(10.0),
//
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             const Text(
//                               'Total Closing Balance',
//                               style: TextStyle(fontSize: 22, color: Colors.white),
//                             ),
//
//                             Text(
//                               '$formattedTotalAmount',
//                               style: const TextStyle(fontSize: 22, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     if (filteredList!.isEmpty) ...[
//                       Center(
//                         child: SizedBox(
//                           height: 200,
//                           child: Center(child: Text('No data found')),
//                         ),
//                       ),
//                     ] else ...[
//                       Expanded(
//                         child: ListView.separated(
//                           shrinkWrap: true,
//                           itemCount: filteredList!.length,
//                           separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
//                           itemBuilder: (context, index) {
//                             var formateAmount =
//                                 NumberFormat("#,##0.##", "en_US")
//                                     .format(double.parse(
//                               filteredList![index].balance.toString(),
//                             ));
//                             CustomerBalanceModel selectedCustomer =
//                                 filteredList![index];
//                             return ListTile(
//                               tileColor: index.isEven ? Colors.blueGrey[50] : Colors.blue[50],
//                               title: Text('${filteredList![index].name}',
//                                 style: TextStyle(fontSize: 14),),
//                               trailing: Text('${formateAmount}',
//                                 style: TextStyle(fontSize: 14),)
//                             );
//                             // return balanceListCard(
//                             //   context,
//                             //   filteredList![index].name ?? "Customer Name",
//                             //   formateAmount,
//                             //   Theme.of(context).colorScheme.secondary,
//                             //   ontap: () {
//                             //     _searchController.clear();
//                             //     Get.to(
//                             //       CustomerLedgerScreen(
//                             //         selectedCustomerName: selectedCustomer.name,
//                             //         selectedCustomerId: selectedCustomer.pkcode,
//                             //       ),
//                             //       transition: Transition.leftToRightWithFade,
//                             //     );
//                             //   },
//                             // );
//                           },
//                         ),
//                       ),
//                     ],
//                     SizedBox(height: 10),
//                   ],
//                 ),
//         ],
//       ),
//     );
//   }
//
//   SizedBox balanceListCard(context, String? title, String? Qty, Color color,
//       {Callback? ontap}) {
//     return SizedBox(
//       width: double.infinity,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: InkWell(
//               onTap: ontap,
//               child: Card(
//                 color: color,
//                 elevation: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Text(
//                         '$title',
//                         overflow: TextOverflow.visible,
//                         // maxLines: 1,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Theme.of(context).colorScheme.onPrimary,
//                         ),
//                       ),
//                     ),
//                     // child: FittedBox(
//                     //   child: MyTextWidget(
//                     //     size: 14.0,
//                     //     text: '$title',
//                     //     color: Theme.of(context).colorScheme.onPrimary,
//                     //     fontWeight: FontWeight.w600,
//                     //   ),
//                     // ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Card(
//               color: color,
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Text(
//                       '$Qty',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Theme.of(context).colorScheme.onPrimary,
//                       ),
//                     ),
//                   ),
//                   // child: FittedBox(
//                   //   child: MyTextWidget(
//                   //     text: '$Qty',
//                   //     color: Theme.of(context).colorScheme.onPrimary,
//                   //     fontWeight: FontWeight.w600,
//                   //   ),
//                   // ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildDivider() {
//     return Divider(
//       thickness: 1,
//       color: Colors.blueAccent,
//     );
//   }
// }
