import 'package:dropdown_search/dropdown_search.dart';
import 'package:scarlet_erm/components/finance_drawer.dart';
import 'package:scarlet_erm/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../components/roundbutton.dart';
import '../../../../components/text_widget.dart';
import '../../../../services/api_service.dart';
import 'customer_ledger_preview.dart';

class CustomerLedgerScreen extends StatefulWidget {
  CustomerLedgerScreen(
      {super.key, this.selectedCustomerName, this.selectedCustomerId});
  final String? selectedCustomerId;
  final String? selectedCustomerName;

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  final formKey = GlobalKey<FormState>();
  String? _pkCode;
  bool isLoading = true;
  final dateFormat = DateFormat("dd-MMM-yyyy");
  String? usid;

  bool isDrawerOpen = false;

  final startDateController = TextEditingController();
  final EndDateController = TextEditingController();

  //get customer Api
  ///////////////////
  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('x')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    debugPrint(s);
  }

  String? _customerValue = "Select Customer";

  // String? selectedCustomerValue ="Select Customer";
  List<String>? customersList = [];
  List<String> pkCodes = [];

  Future<void> _fetchCustomer2() async {
    try {
      final data = await ApiService.get("Balances/CustomerBalance");
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("NAME") &&
            item.containsKey("PKCODE") &&
            item["NAME"] is String &&
            item["PKCODE"] is String) {
          String name = item['NAME'];
          String pkCode = item['PKCODE'];
          if (!menuItems.contains(name) && !pkCodes.contains(pkCode)) {
            menuItems.add(name);
            pkCodes.add(pkCode);
          }
        }
      }

      setState(() {
        customersList = menuItems;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }
  //////////////////

  valueFromPriviouScreen() {
    if (_customerValue != null) {
      setState(() {
        _customerValue = widget.selectedCustomerName;
        _pkCode = widget.selectedCustomerId;
        debugPrint(_customerValue = widget.selectedCustomerName);
        debugPrint(_pkCode = widget.selectedCustomerId);
      });
    } else {
      setState(() {
        _customerValue = "Select Customer";
      });
    }
  }

  @override
  void initState() {
    usid = GetStorage().read('usid');
    debugPrint("KKKKKKKKKKKKKKKKKKK$usid");

    _fetchCustomer2();
    valueFromPriviouScreen();
    // Set the default values for start and end date text fields
    final DateTime now = DateTime.now();
    final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    startDateController.text = dateFormat.format(firstDayOfMonth);
    EndDateController.text = dateFormat.format(lastDayOfMonth);

    super.initState();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        controller.text = dateFormat.format(picked);
      });
    }
  }

  // _clearController() {
  //   startDateController.clear();
  //   EndDateController.clear();
  //   setState(() {
  //     _customerValue = "Select Customer";
  //   });
  // }

  String selectedDateRange = 'Current Month';
  String getPreviousMonthName() {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1);
    final previousMonthFormatted = DateFormat('MMM').format(previousMonth);
    return previousMonthFormatted;
  }

  String getPreviousMonthName2() {
    final now = DateTime.now();
    final previousMonth2 = DateTime(now.year, now.month - 2);
    final previousMonthFormatted2 = DateFormat('MMM').format(previousMonth2);
    return previousMonthFormatted2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.white60,
      endDrawer: FinanceDrawer(voucher: Colors.grey, payment: Colors.grey,
        custBal: Colors.grey, custLedger: Color(0xFF144b9d),),
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        title: Text("Customer Ledger"),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  MyTextWidget(
                      text: '    Select Customer',
                      color: Theme.of(context).colorScheme.primary),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownSearch<String>(
                      dropdownBuilder: (context, selectedItem) {
                        return Text(
                          selectedItem.toString() == 'null'
                              ? 'Select from dropdown menu'
                              : selectedItem.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      },
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: isItemDisabled,
                        showSearchBox:
                            true, // Add this line to enable the search box
                      ),
                      items: customersList ?? [],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: Theme.of(context).colorScheme.primary,
                          hintText: "Search here", // Set the hint text
                        ),
                      ),
                      selectedItem: _customerValue,
                      onChanged: (value) {
                        setState(() {
                          _customerValue = value;
                          debugPrint("..customername..$_customerValue");

                          _pkCode = pkCodes[customersList!.indexOf(value!)];
                          debugPrint("..pkcode..$_pkCode");
                        });
                      },
                      validator: (value) {
                        if (value == "Select Customer") {
                          return "Please select a customer";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextForm(
                      dateMask: "##-???-####",
                      text: 'Start Date',
                      containerWidth: double.infinity,
                      hintText: 'DD-MMM-YYYY',
                      controller: startDateController,
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return "Start Date is required";
                        }
                      },
                      sufixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        onPressed: () =>
                            _selectDate(context, startDateController),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MyTextForm(
                      dateMask: "##-???-####",
                      text: 'End Date',
                      sufixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        onPressed: () =>
                            _selectDate(context, EndDateController),
                      ),
                      containerWidth: double.infinity,
                      hintText: 'DD-MMM-YYYY',
                      controller: EndDateController,
                      validator: (text) {
                        if (text.toString().isEmpty) {
                          return "End Date is required";
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: RadioListTile(
                          dense: true,
                          title: Text(
                              '${DateFormat('MMM').format(DateTime.now())}',
                          style: TextStyle(color: Colors.black),),
                          value: 'Current Month',
                          groupValue: selectedDateRange,
                          onChanged: (value) {
                            setState(() {
                              selectedDateRange = value!;

                              // Update the selected dates
                              final DateTime now = DateTime.now();
                              final DateTime firstDayOfMonth =
                                  DateTime(now.year, now.month, 1);
                              final DateTime lastDayOfMonth =
                                  DateTime(now.year, now.month + 1, 0);
                              startDateController.text =
                                  dateFormat.format(firstDayOfMonth);
                              EndDateController.text =
                                  dateFormat.format(lastDayOfMonth);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RadioListTile(
                          dense: true,
                          title: Text('${getPreviousMonthName()}',
                            style: TextStyle(color: Colors.black),),
                          value: 'Previous Month',
                          groupValue: selectedDateRange,
                          onChanged: (value) {
                            setState(() {
                              selectedDateRange = value!;

                              // Update the selected dates
                              final DateTime now = DateTime.now();
                              final DateTime previousMonth =
                                  DateTime(now.year, now.month - 1);
                              final DateTime firstDayOfMonth = DateTime(
                                  previousMonth.year, previousMonth.month, 1);
                              final DateTime lastDayOfMonth = DateTime(
                                  previousMonth.year,
                                  previousMonth.month + 1,
                                  0);
                              startDateController.text =
                                  dateFormat.format(firstDayOfMonth);
                              EndDateController.text =
                                  dateFormat.format(lastDayOfMonth);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: RadioListTile(

                          dense: true,
                          title: Text('${getPreviousMonthName2()}',
                            style: TextStyle(color: Colors.black),),
                          value: 'Next Month',
                          groupValue: selectedDateRange,
                          onChanged: (value) {
                            setState(() {
                              selectedDateRange = value!;

                              // Update the selected dates
                              final DateTime now = DateTime.now();
                              final DateTime nextMonth =
                                  DateTime(now.year, now.month - 2);
                              final DateTime firstDayOfMonth = DateTime(
                                  nextMonth.year, nextMonth.month, 1);
                              final DateTime lastDayOfMonth = DateTime(
                                  nextMonth.year, nextMonth.month + 1, 0);
                              startDateController.text =
                                  dateFormat.format(firstDayOfMonth);
                              EndDateController.text =
                                  dateFormat.format(lastDayOfMonth);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RoundButton(
                      width: double.infinity,
                      // loading: loading,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onTap: () {
                        debugPrint(_pkCode);
                        debugPrint(startDateController.text);
                        debugPrint(EndDateController.text);

                        if (formKey.currentState!.validate()) {
                          if (_customerValue == "Select Customer") {
                            Get.snackbar(
                              'Error Message',
                              'Please select valid value',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else {
                            Get.to(CustomeLedgerPreview(
                              fromDate: startDateController.text,
                              ToDate: EndDateController.text,
                              psctd: _pkCode,
                            ));
                            // _clearController();
                          }
                        }
                      },
                      title: "Preview",
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
  Widget buildDivider() {
    return Divider(
      thickness: 1,
      color: Colors.blueAccent,
    );
  }
}
