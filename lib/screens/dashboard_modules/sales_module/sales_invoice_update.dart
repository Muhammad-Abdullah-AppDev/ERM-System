import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scarlet_erm/models/sales_vcDtl_model.dart';
import 'package:get/get.dart';
import 'package:scarlet_erm/screens/dashboard_modules/sales_module/sales_invoice.dart';

import '../../../models/get_account_no_dialog.dart';
import '../../../models/response_data_model.dart';
import '../../../services/api_service.dart';

class SalesInvoiceUpdate extends StatefulWidget {
  var srno;
  var status;
  var customer;
  var vdt;
  var remarks;

  SalesInvoiceUpdate(
      {super.key,
      required this.srno,
      required this.status,
      required this.customer,
      required this.vdt,
      required this.remarks});

  @override
  State<SalesInvoiceUpdate> createState() => _SalesInvoiceUpdateState();
}

class _SalesInvoiceUpdateState extends State<SalesInvoiceUpdate> {
  final DataController dataController = Get.put(DataController());

  DateTime? selectedDate;
  String? dateText;
  String? dateTime;
  var selectedPKCODE;

  bool isLoading = false;
  String? selectedValueOne;
  var selectedValue;
  String? selectedBankAccount;
  final _formKey = GlobalKey<FormState>();

  TextEditingController voucherNumberController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  GetStorage _box = GetStorage();

  List<DialogAccountNumberDataModel> dialogaccountNumbers = [];
  String? selectedDialogAccountNumber;

  Future<void> sendUpdateRequest(
      String? fkMastValue, String rmks, String usid) async {
    try {
      var url = Uri.parse(
          '${ApiService.baseUrl}DirectSaleInvoice/UpdateSaleInvoiceMast');
      Map<String, dynamic> body = {
        "SRNO": '${voucherNumberController.text}',
        "FKFSCD": '$fkMastValue',
        "RMKS": '$rmks',
        "USID": '$usid'
      };
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        // Parse the response
        var responseData =
            ResponseDataModel.fromJson(json.decode(response.body));
        // Update the TextFields
        setState(() {
          voucherNumberController.text = responseData.serialno ?? "N/A";
          statusController.text =
              responseData.status == "0" ? "SAVED" : "VERIFIED";
          isLoading = !isLoading;
        });
        Fluttertoast.showToast(
            msg: "Data Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 15.0);
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.body}');
        Fluttertoast.showToast(
            msg: "Failed To Update Data",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
        setState(() {
          isLoading = !isLoading;
        });
      }
    } catch (e) {
      // Handle the error here
      debugPrint('Error: $e');
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  Future<void> _refreshListDetails() async {
    //await fetchListDetails();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1990),
  //     lastDate: DateTime(2040),
  //   );
  //
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });
  //   }
  // }

  Future<void> submitData() async {
    // Validation checks
    if (remarksController.text.isEmpty || _accountValue == null) {
      setState(() {
        isLoading = !isLoading;
      });
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return;
    }
    String? fkMastValue = _pkCodeAcc;
    String? usid = _box.read('usid').toString().toUpperCase();
    String rmks = remarksController.text.toString();

    await sendUpdateRequest(fkMastValue, rmks, usid);
  }

  // Future submitDataDilaog(_pkCodeList) async {
  //   if (dialogvoucherAmountController.text.isEmpty ||
  //       dialogRemarksController.text.isEmpty ||
  //       _pkCodeList == null) {
  //     // if (dialogvoucherAmountController.text.isEmpty) {
  //     Fluttertoast.showToast(
  //         msg: "All Fields are Required",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP_LEFT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.yellow.shade800,
  //         textColor: Colors.white,
  //         fontSize: 15.0);
  //     return true; // Return early as validation failed
  //   } else {
  //     String fkMastValueDialog = _pkCodeList;
  //
  //     PostDataModelDialog postDataDialog = PostDataModelDialog(
  //       theamountDialog: dialogvoucherAmountController.text,
  //       srnoDialog: voucherNumberController.text,
  //       fkMastDialog: fkMastValueDialog,
  //       remksDialog: dialogRemarksController.text,
  //     );
  //     await sendPostRequestPaymentDialog(postDataDialog, context);
  //   }
  // }

  // Future<List<SalesVcDtlModel>> fetchListDetails() async {
  //   String srno = voucherNumberController.text;
  //   // String srno = "2024-01-BPV-0040";
  //   debugPrint('Voucher Number this time is : ${voucherNumberController.text}');
  //   var url = Uri.parse(
  //       'https://erm.scarletsystems.com:1235/Api/DirectSaleInvoice/getListDtl?srno=$srno');
  //   var response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse
  //         .map((data) => SalesVcDtlModel.fromJson(data))
  //         .toList();
  //   } else {
  //     debugPrint('Failed to load list details');
  //     throw Exception('Failed to load list details');
  //   }
  // }

  Future deleteRecord(String srno, int trno) async {
    var deleteUrl = Uri.parse(
        '${ApiService.baseUrl}DirectSaleInvoice/DeleteDetailVoucher?srno=$srno&trno=$trno');
    var response = await http.get(deleteUrl);

    if (response.statusCode == 200) {
      // Handle successful deletion
      Fluttertoast.showToast(
        msg: "Record Deleted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return response;
    } else {
      debugPrint("Response Code: ${response.statusCode}");
      debugPrint("Error: ${response.body}");
      Fluttertoast.showToast(
        msg: "Failed To Delete Record",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  String? _pkCodeAcc;
  // String? _pkCodeItemList;
  // String? _locCodeItemList;
  // String? _fkmastUOMList;
  String? _accountValue = 'Loading Customer';
  // String? _dialogItemValue = "Select Item";
  // String? _dialogUOMValue = "Select UOM";
  List<String>? accountCustList = [];
  List<String>? accountDialogItemList = [];
  List<String>? accountUOMList = [];
  List<String> pkCodesAcc = [];
  List<String> codesFkmast = [];
  List<String> pkCodesDialogItem = [];
  List<String> locCodesDialogItem = [];

  Future<void> getCustomerAccount() async {
    try {
      final data = await ApiService.get('Balances/CustomerBalance');
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("NAME") &&
            item.containsKey("PKCODE") &&
            item["NAME"] is String &&
            item["PKCODE"] is String) {
          String name = item['NAME'];
          String pkCode = item['PKCODE'];
          if (!menuItems.contains(name) && !pkCodesAcc.contains(pkCode)) {
            menuItems.add(name);
            pkCodesAcc.add(pkCode);
          }
        }
      }
      setState(() {
        accountCustList = menuItems;
        int selectedIndex = pkCodesAcc.indexOf(selectedPKCODE);
        String accountName = accountCustList![selectedIndex];
        _accountValue = accountName;
        _pkCodeAcc = pkCodesAcc[accountCustList!.indexOf(_accountValue!)];
        debugPrint('Customer Accounts: $accountCustList');
        debugPrint('Selected Account: $_accountValue');
        debugPrint('Selected pkCode: $_pkCodeAcc');
        isLoading = false;
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  // Future<void> fetchUOMData(String? pkCodeItemList) async {
  //   try {
  //     final data = await ApiService.get(
  //         'DirectSaleInvoice/GetUOM?fkmast=$pkCodeItemList');
  //     List<String> menuItems = [];
  //
  //     for (var item in data) {
  //       if (item is Map<String, dynamic> &&
  //           item.containsKey("FKMAST") &&
  //           item.containsKey("FKUOM") &&
  //           item["FKMAST"] is String &&
  //           item["FKUOM"] is String) {
  //         String name = item['FKUOM'];
  //         String fkmast = item['FKMAST'];
  //         if (!menuItems.contains(name) && !codesFkmast.contains(fkmast)) {
  //           menuItems.add(name);
  //           codesFkmast.add(fkmast);
  //         }
  //       }
  //     }
  //     setState(() {
  //       accountUOMList = menuItems;
  //       debugPrint('UOM Data: $accountUOMList');
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     debugPrint("An error occurred: $e");
  //   }
  // }
  void resetFields() {
    // Resetting TextControllers
    remarksController.clear();
    voucherNumberController.clear();
    statusController.clear();
    // Resetting other variables (dropdowns, lists, etc.)
    selectedBankAccount = null;
    selectedDialogAccountNumber = null;

    dialogaccountNumbers.clear();
  }

  // void resetDialogFields() {
  //   // Resetting TextControllers
  //   dialogRemarksController.clear();
  //   dialogvoucherAmountController.clear();
  //   selectedDialogAccountNumber = null;
  //   dialogaccountNumbers.clear();
  //
  //   accountDialogItemList!.clear();
  //   // _dialogItemValue = "Select Item";
  //   // _dialogUOMValue = "Select UOM";
  //   accountUOMList!.clear();
  //   codesFkmast.clear();
  //   pkCodesDialogItem.clear();
  //   locCodesDialogItem.clear();
  // }

  @override
  void initState() {
    super.initState();
    // Optionally preload data if required
    getCustomerAccount(); // Fetch data when the widget is initialized
    resetFields();
    voucherNumberController.text = widget.srno;
    statusController.text = widget.status;
    remarksController.text = widget.remarks;
    dateTime = widget.vdt;
    dateText = dateTime!.split('T')[0];
    selectedPKCODE = widget.customer;
    debugPrint("Customer Number : $selectedPKCODE");
  }

  @override
  void dispose() {
    dataController.dispose();
    //searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Sales Invoice',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            resetFields();
          },
          icon: const Padding(
            padding: EdgeInsets.only(left: 14.0),
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: Colors.green,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        displacement: 30,
        color: Colors.green,
        strokeWidth: RefreshProgressIndicator.defaultStrokeWidth,
        onRefresh: _refreshListDetails,
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 8,
                    right: 8,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 12, left: 10, right: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5.0),
                                          child: Text(
                                            'Voucher Number',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF022F8E)),
                                          ),
                                        ),
                                        TextField(
                                          controller: voucherNumberController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              prefix: const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 08,
                                                ),
                                              ),
                                              filled: true,
                                              enabled: false,
                                              hintText: "Voucher Number",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              fillColor: Colors.grey.shade200,
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Colors
                                                        .blueGrey.shade600,
                                                    width: 2.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: Colors
                                                        .blueGrey.shade600,
                                                    width: 2.0),
                                              )),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueGrey.shade300,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      TextField(
                                        controller: statusController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          prefix: const Padding(
                                            padding: EdgeInsets.only(
                                              left: 08,
                                            ),
                                          ),
                                          filled: true,
                                          enabled: false,
                                          hintText: "Status",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          fillColor: Colors.grey.shade200,
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey.shade600,
                                                width: 2.0),
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey.shade300,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          'Customer Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      Container(
                                        height: 57,
                                        padding: EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.blueGrey.shade600,
                                                width: 2.0)),
                                        child: DropdownSearch<String>(
                                          dropdownBuilder:
                                              (context, selectedItem) {
                                            return Text(
                                              selectedItem.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            );
                                          },
                                          popupProps: PopupProps.menu(
                                            showSelectedItems: true,
                                            showSearchBox:
                                                true, // Add this line to enable the search box
                                          ),
                                          items: accountCustList ?? [],
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              iconColor: Colors.black,
                                              isDense: true,
                                              hintText: "Search here",
                                            ),
                                          ),
                                          selectedItem: _accountValue,
                                          onChanged: (value) {
                                            setState(() {
                                              _accountValue = value;
                                              debugPrint(
                                                  "Account Name..$_accountValue");

                                              _pkCodeAcc = pkCodesAcc[
                                                  accountCustList!
                                                      .indexOf(value!)];
                                              debugPrint("pkcode..$_pkCodeAcc");
                                            });
                                          },
                                          validator: (value) {
                                            if (value == "Select Account") {
                                              return "Please select an Account";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          'Voucher Date',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.48,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.blueGrey.shade600,
                                                width: 2.0)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dateText == null
                                                    ? ''
                                                    : dateText!,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54),
                                              ),
                                              Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Colors.orange)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          'Remarks',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: remarksController,
                                        validator: (remarks) =>
                                            remarks!.isEmpty ? "" : null,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          enabled: true,
                                          hintText: "Enter Remarks...",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          fillColor: Colors.grey.shade200,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey.shade600,
                                                width: 2.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.red.shade600,
                                                width: 2.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey.shade600,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 52,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 1,
                                              blurRadius: 4)
                                        ]),
                                    child: TextButton(
                                      onPressed: () {
                                        debugPrint(
                                            'Validate: ${_formKey.currentState!.validate()}');
                                        _formKey.currentState!.validate();
                                        submitData();
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        // Make sure to call submitData() correctly
                                      },
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      //resetDialogFields();
                      // openDialog(context);
                      if (voucherNumberController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Save The Voucher Details First",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red.shade800,
                            textColor: Colors.white,
                            fontSize: 15.0);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyDialog(
                                button: false,
                                srno: voucherNumberController.text);
                          },
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/the_plus.png',
                          width: 40,
                          height: 40,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Voucher Details (Required)',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12.0, left: 4, right: 4),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orangeAccent.shade200),
                                child: const Padding(
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            'Item Code',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Qty',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Rate',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'AMT',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder(
                              future: dataController.fetchListDetails(
                                  voucherNumberController.text),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: Text("Loading Data..."));
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  return Obx(() => dataController
                                          .data.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                dataController.data.length,
                                            itemBuilder: (context, index) {
                                              // your existing list item build code
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 4,
                                                    right: 4),
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    extentRatio: 2 / 5,
                                                    motion:
                                                        const DrawerMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          String? currentSrno =
                                                              voucherNumberController
                                                                  .text;
                                                          debugPrint(
                                                              '$currentSrno');
                                                          var currentTrno =
                                                              dataController
                                                                  .data[index]
                                                                  .tRNO;
                                                          debugPrint(
                                                              '$currentTrno');
                                                          var fkMast =
                                                              dataController
                                                                  .data[index]
                                                                  .fKMAST;
                                                          var qty =
                                                              dataController
                                                                  .data[index]
                                                                  .qTY;
                                                          var rate =
                                                              dataController
                                                                  .data[index]
                                                                  .rATE;
                                                          var nAmt =
                                                              dataController
                                                                  .data[index]
                                                                  .nETAMT;
                                                          var gAmt =
                                                              dataController
                                                                  .data[index]
                                                                  .gRAMT;
                                                          var dAmt =
                                                              dataController
                                                                  .data[index]
                                                                  .dAMT;
                                                          var fkUOM =
                                                              dataController
                                                                  .data[index]
                                                                  .fKUOM;
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return MyDialog(
                                                                  trno:
                                                                      currentTrno,
                                                                  button: true,
                                                                  itemNo:
                                                                      fkMast,
                                                                  uom: fkUOM,
                                                                  qty: qty,
                                                                  rate: rate,
                                                                  nAmt: nAmt,
                                                                  gAmt: gAmt,
                                                                  dAmt: dAmt,
                                                                  srno: currentSrno);
                                                            },
                                                          );
                                                        },
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.edit,
                                                      ),
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          String? currentSrno =
                                                              voucherNumberController
                                                                  .text;
                                                          debugPrint(
                                                              '$currentSrno');
                                                          var currentTrno =
                                                              dataController
                                                                  .data[index]
                                                                  .tRNO;
                                                          debugPrint(
                                                              '$currentTrno');
                                                          showDeleteDialog(
                                                              context,
                                                              currentSrno,
                                                              currentTrno);
                                                        },
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        backgroundColor:
                                                            Colors.red,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons
                                                            .delete_outline_rounded,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.92,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: index % 2 == 0
                                                            ? Colors.blueGrey
                                                                .shade50
                                                            : Colors
                                                                .blue.shade50),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 5.0, right: 5.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  flex: 7,
                                                                  child: Text(
                                                                    (dataController
                                                                            .data[index]
                                                                            .iTEM_NAME ??
                                                                        "N/A"),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '${dataController.data[index].qTY ?? "N/A"}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    textAlign: TextAlign.right,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '${dataController.data[index].rATE ?? "N/A"}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    textAlign: TextAlign.right,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '${dataController.data[index].nETAMT ?? "N/A"}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    textAlign: TextAlign.right,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Expanded(
                                          child: Center(
                                              child: Text("No data found!"))));
                                }
                              }),
                          const SizedBox(height: 8)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(
      BuildContext context, String? currentSrno, int? currentTrno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Voucher'),
          content: isLoading
              ? const CircularProgressIndicator()
              : const Text('Are you sure you want to delete this Voucher?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = !isLoading;
                });
                var responseBody =
                    await deleteRecord(currentSrno!, currentTrno!);
                if (responseBody != null) {
                  setState(() {
                    isLoading = !isLoading;
                  });
                } else {
                  setState(() {
                    isLoading = !isLoading;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(6.0),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return isLoading ? Colors.grey : Colors.redAccent;
                  },
                ),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

//Future<List<SalesVcDtlModel>> listDetails = fetchListDetails(voucherNumberController.text);

class MyDialog extends StatefulWidget {
  var srno;
  //Future<List<SalesVcDtlModel>> Function() updateDtl;
  var trno;
  bool button;
  var itemNo;
  var uom;
  var qty;
  var rate;
  var nAmt;
  var gAmt;
  var dAmt;

  MyDialog(
      {this.trno,
      required this.button,
      this.itemNo,
      this.uom,
      this.qty,
      this.rate,
      this.nAmt,
      this.gAmt,
      this.dAmt,
      required this.srno});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final DataController dataController = Get.put(DataController());

  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController grossAmtController = TextEditingController();
  TextEditingController discountAmtController = TextEditingController();
  TextEditingController netAmtController = TextEditingController();
  TextEditingController voucherNumberController = TextEditingController();

  bool btn = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? _pkCodeItemList;
  String? _locCodeItemList;
  String? _dialogItemValue = "Select Item";
  String? _dialogUOMValue = "Select UOM";
  List<String>? accountCustList = [];
  List<String>? accountDialogItemList = [];
  List<String>? accountUOMList = [];
  List<String> pkCodesAcc = [];
  List<String> codesFkmast = [];
  List<String> pkCodesDialogItem = [];
  List<String> locCodesDialogItem = [];

  var selectedPKCODE;
  var selectedUOM;
  String? _pkCode;
  var trno;

  Future<void> fetchItemData() async {
    try {
      Fluttertoast.showToast(
          msg: "Wait for Items Names",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
      final data = await ApiService.get("DirectSaleInvoice/GetItem");
      //debugPrint('Data: $data');
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("PKCODE") &&
            item.containsKey("NAME") &&
            item.containsKey("FKWHCD") &&
            item["PKCODE"] is String &&
            item["NAME"] is String &&
            item["FKWHCD"] is String) {
          String pkCode = item['PKCODE'];
          String name = item['NAME'];
          String locCode = item['FKWHCD'];
          if (!menuItems.contains(name) ||
              !pkCodesDialogItem.contains(pkCode) ||
              !locCodesDialogItem.contains(locCode)) {
            menuItems.add(name);
            pkCodesDialogItem.add(pkCode);
            locCodesDialogItem.add(locCode);
          }
        }
      }
      setState(() {
        if (btn == true) {
          accountDialogItemList = menuItems;
          int selectedIndex = pkCodesDialogItem.indexOf(selectedPKCODE);
          String accountName = accountDialogItemList![selectedIndex];
          _dialogItemValue = accountName;
          _pkCode = pkCodesDialogItem[
              accountDialogItemList!.indexOf(_dialogItemValue!)];
          //debugPrint('Bank Accounts: $accountBankList');
          debugPrint('Selected Account: $_dialogItemValue');
          debugPrint('Selected pkCode: $_pkCode');

          _pkCodeItemList = pkCodesDialogItem[
              accountDialogItemList!.indexOf(_dialogItemValue!)];
          debugPrint("pkcode: $_pkCodeItemList");
          _locCodeItemList = locCodesDialogItem[
              accountDialogItemList!.indexOf(_dialogItemValue!)];
          debugPrint("loc: $_locCodeItemList");

          fetchUOMData(_pkCode);

          isLoading = false;
        } else {
          debugPrint('Menu Items: $menuItems');
          accountDialogItemList = menuItems;
          debugPrint('Dialog Accounts: $accountDialogItemList');
          isLoading = false;
          Fluttertoast.showToast(
              msg: "DropDown Items Are Available",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  Future<void> fetchUOMData(String? pkCodeItemList) async {
    try {
      final data = await ApiService.get(
          'DirectSaleInvoice/GetUOM?fkmast=$pkCodeItemList');
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("FKMAST") &&
            item.containsKey("FKUOM") &&
            item["FKMAST"] is String &&
            item["FKUOM"] is String) {
          String name = item['FKUOM'];
          String fkmast = item['FKMAST'];
          if (!menuItems.contains(name) || !codesFkmast.contains(fkmast)) {
            menuItems.add(name);
            codesFkmast.add(fkmast);
          }
        }
      }
      setState(() {
        if (btn == true) {
          accountUOMList = menuItems;
          int selectedIndex = menuItems.indexOf(selectedUOM);
          String accountName = accountUOMList![selectedIndex];
          _dialogUOMValue = accountName;
        } else {
          accountUOMList = menuItems;
          debugPrint('UOM Data: $accountUOMList');
          isLoading = false;
        }
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  void calculateGrossAmount() {
    setState(() {
      try {
        double? quantity = double.tryParse(quantityController.text.trim());
        double? rate = double.tryParse(rateController.text.trim());
        double? discAmnt = double.tryParse(discountAmtController.text.trim());

        if (quantity != null && rate != null) {
          var amount = quantity * rate;
          var netAmt = amount - discAmnt!;
          grossAmtController.text = amount.toStringAsFixed(2);
          netAmtController.text = netAmt.toStringAsFixed(2);
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    });
  }

  Future updateDataDialog(String? pkCodeItemList, String? locCodeItemList,
      String? dialogUOMValue, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      double discountPercentage = 0.0;
      if (discountAmtController.text.isNotEmpty && grossAmtController.text.isNotEmpty) {
        double discountAmount = double.parse(discountAmtController.text);
        double grossAmount = double.parse(grossAmtController.text);

        if (grossAmount != 0) {
          discountPercentage = (discountAmount / grossAmount) * 100;
        }
      }
      debugPrint("Posted Values: ${voucherNumberController.text.toString()} \n"
          "$pkCodeItemList \n $dialogUOMValue \n $locCodeItemList \n "
          "${quantityController.text.toString()} \n ${rateController.text.toString()} \n"
          "${grossAmtController.text.toString()} \n $discountPercentage");
      try {
        var url = Uri.parse(
            '${ApiService.baseUrl}DirectSaleInvoice/UpdateSLInvoiceDtl');

        Map<String, dynamic> body = {
          "SRNO": "${voucherNumberController.text.toString()}",
          "TRNO": "${trno}",
          "FKMAST": "$pkCodeItemList",
          "FKUOM": "$dialogUOMValue",
          "FKWLOC": "$locCodeItemList",
          "QTY": "${quantityController.text.toString()}",
          "Rate": "${rateController.text.toString()}",
          "GRAMT": "${grossAmtController.text.toString()}",
          "DPER": "$discountPercentage",
          "DAMT": "${discountAmtController.text.toString()}",
          "NETAMT": "${netAmtController.text.toString()}",
        };

        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          setState(() {
            dataController.fetchListDetails(voucherNumberController.text);
          });
          Get.back();
          //Navigator.of(context).pop("${fetchListDetails()}");
          Fluttertoast.showToast(
              msg: "Data Saved Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 15.0);
          //widget.updateDtl;
          debugPrint('Request status code: ${response.statusCode}');
        } else {
          debugPrint('Error: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
          Fluttertoast.showToast(
              msg: "Failed To Save Record",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      } catch (e) {
        debugPrint("Error: $e");
        throw e;
      }
    } else {
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return false;
    }
  }

  Future submitDataDialog(String? pkCodeItemList, String? locCodeItemList,
      String? dialogUOMValue, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      //String fkMastValueDialog = _pkCodeList;
      // PostDataModelDialog postDataDialog = PostDataModelDialog(
      //   theamountDialog: dialogvoucherAmountController.text,
      //   srnoDialog: voucherNumberController.text,
      //   fkMastDialog: fkMastValueDialog,
      //   remksDialog: dialogRemarksController.text,
      // );
      //await sendPostRequestDialog(context);
      double discountPercentage = 0.0;
      if (discountAmtController.text.isNotEmpty && grossAmtController.text.isNotEmpty) {
        double discountAmount = double.parse(discountAmtController.text);
        double grossAmount = double.parse(grossAmtController.text);

        if (grossAmount != 0) {
          discountPercentage = (discountAmount / grossAmount) * 100;
        }
      }
      debugPrint("Posted Values: ${voucherNumberController.text.toString()} \n"
          "$pkCodeItemList \n $dialogUOMValue \n $locCodeItemList \n "
          "${quantityController.text.toString()} \n ${rateController.text.toString()} \n"
          "${grossAmtController.text.toString()}");
      try {
        var url = Uri.parse(
            '${ApiService.baseUrl}DirectSaleInvoice/PostSLInvoiceDtl');

        Map<String, dynamic> body = {
          "SRNO": '${voucherNumberController.text.toString()}',
          "FKMAST": '$pkCodeItemList',
          "FKUOM": '$dialogUOMValue',
          "FKWLOC": '$locCodeItemList',
          "QTY": '${quantityController.text.toString()}',
          "Rate": '${rateController.text.toString()}',
          "GRAMT": '${grossAmtController.text.toString()}',
          "DPER": '$discountPercentage',
          "DAMT": '${discountAmtController.text.toString()}',
          "NETAMT": '${netAmtController.text.toString()}'
        };

        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          setState(() {
            dataController.fetchListDetails(voucherNumberController.text);
          });
          Get.back();
          //Navigator.of(context).pop("${fetchListDetails()}");
          Fluttertoast.showToast(
              msg: "Data Saved Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 15.0);
          //widget.updateDtl;
          debugPrint('Request status code: ${response.statusCode}');
        } else {
          debugPrint('Error: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
          Fluttertoast.showToast(
              msg: "Failed To Save Record",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP_LEFT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      } catch (e) {
        debugPrint("Error: $e");
        throw e;
      }
    } else {
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return false;
    }
  }

  // void callFunctionFromAnotherWidget() {
  //   SalesInvoiceUpdate salesInvoiceWidget = SalesInvoiceUpdate();
  //   salesInvoiceWidget.key; // Call function from AnotherStatefulWidget
  // }
  Future<List<SalesVcDtlModel>> fetchListDetails() async {
    String srno = voucherNumberController.text;
    // String srno = "2024-01-BPV-0040";
    debugPrint('Voucher Number this time is : $voucherNumberController');
    var url = Uri.parse(
        '${ApiService.baseUrl}DirectSaleInvoice/getListDtl?srno=$srno');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => SalesVcDtlModel.fromJson(data))
          .toList();
    } else {
      debugPrint('Failed to load list details');
      throw Exception('Failed to load list details');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItemData();
    voucherNumberController.text = widget.srno;
    btn = widget.button;
    widget.button == true
        ? discountAmtController.text = widget.dAmt.toString()
        : discountAmtController.text = '0';
    selectedPKCODE = widget.itemNo;
    selectedUOM = widget.uom;
    trno = widget.trno;
    widget.button == true
        ? quantityController.text = widget.qty.toString()
        : "";
    widget.button == true ? rateController.text = widget.rate.toString() : "";
    widget.button == true
        ? grossAmtController.text = widget.gAmt.toString()
        : "";
    widget.button == true ? netAmtController.text = widget.nAmt.toString() : "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Center(
          child: Text(
        'Sales Voucher Details',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
      )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: ListBody(
            children: <Widget>[
              Text(
                ' Item Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blueGrey.shade600, width: 2.0),
                ),
                child: DropdownSearch<String>(
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    );
                  },
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox:
                        true, // Add this line to enable the search box
                  ),
                  items: accountDialogItemList ?? [],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        iconColor: Colors.black,
                        isDense: true,
                        hintText: "Search here",
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                  selectedItem: _dialogItemValue,
                  onChanged: (value) {
                    setState(() {
                      _dialogItemValue = value;
                      _dialogUOMValue = "Select UOM";
                      debugPrint("Account Name: $_dialogItemValue");

                      _pkCodeItemList = pkCodesDialogItem[
                          accountDialogItemList!.indexOf(value!)];
                      debugPrint("pkcode: $_pkCodeItemList");

                      _locCodeItemList = locCodesDialogItem[
                          accountDialogItemList!.indexOf(value)];
                      debugPrint("locCode: $_locCodeItemList");

                      fetchUOMData(_pkCodeItemList);
                    });
                  },
                  validator: (value) {
                    if (value == "Select Item") {
                      return "Please select a DropDown Item";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ' UOM Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blueGrey.shade600, width: 2.0),
                ),
                child: DropdownSearch<String>(
                  dropdownBuilder: (context, selectedItem) {
                    return Text(
                      selectedItem.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    );
                  },
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    showSearchBox:
                        true, // Add this line to enable the search box
                  ),
                  items: accountUOMList ?? [],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        iconColor: Colors.black,
                        isDense: true,
                        hintText: "Search here",
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                  selectedItem: _dialogUOMValue,
                  onChanged: (_dialogItemValue != null)
                      ? (String? value) {
                          setState(() {
                            _dialogUOMValue = value;
                            debugPrint("UOM Name: $_dialogUOMValue");
                          });
                        }
                      : null,
                  validator: (value) {
                    if (value == "Select Item") {
                      return "Please select a DropDown Item";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Quantity:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 08),
                              ),
                              enabled: true,
                              hintText: "Enter Qty",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              fillColor: Colors.grey.shade200,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              )),
                          onChanged: (value) {
                            calculateGrossAmount();
                          },
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return "Qty is required";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Rate:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              isDense: true,
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 8),
                              ),
                              enabled: true,
                              hintText: "Enter Rate",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              fillColor: Colors.grey.shade200,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              )),
                          onChanged: (value) {
                            calculateGrossAmount();
                          },
                          validator: (text) {
                            if (text.toString().isEmpty) {
                              return "Rate is required";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' DISC AMT:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: discountAmtController,
                          keyboardType: TextInputType.number,
                          readOnly: false,
                          decoration: InputDecoration(
                              isDense: true,
                              enabled: true,
                              hintText: "Enter Amount",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              fillColor: Colors.grey.shade200,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              )),
                          onChanged: (value) {
                            calculateGrossAmount();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' NET AMT:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: netAmtController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 8)),
                              enabled: true,
                              hintText: "",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2.0),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 2.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: btn == true
                      ? Text('Update & Close')
                      : Text('Save & Close'),
                  onPressed: () async {
                    btn == true
                        ? await updateDataDialog(_pkCodeItemList,
                            _locCodeItemList, _dialogUOMValue, context)
                        : await submitDataDialog(_pkCodeItemList,
                            _locCodeItemList, _dialogUOMValue, context);

                    // await fetchListDetails();
                  }),
              const SizedBox(width: 20), // Spacing between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red.shade400,
                  // Text color
                  shadowColor: Colors.black,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the dialog
                },
              ),
            ],
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
