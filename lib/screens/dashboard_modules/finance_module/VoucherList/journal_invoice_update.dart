import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:scarlet_erm/models/update_voucherData_model.dart';
import 'package:get/get.dart';

import '../../../../controllers/invoices_listDtl_controller.dart';
import '../../../../models/get_account_no_dialog.dart';
import '../../../../models/journal_post_detail_model.dart';
import '../../../../models/list_details_model.dart';
import '../../../../models/response_data_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/create_vc_api.dart';

class JournalInvoiceUpdate extends StatefulWidget {
  var srno;
  var status;
  var vcType;
  var remarks;
  var vdt;
  var chqNo;
  var chqDt;
  var accNo;

  JournalInvoiceUpdate(
      {super.key,
      required this.srno,
      required this.status,
      required this.vcType,
      required this.remarks,
      required this.vdt});

  @override
  State<JournalInvoiceUpdate> createState() => _JournalInvoiceUpdateState();
}

class _JournalInvoiceUpdateState extends State<JournalInvoiceUpdate> {
  final ListDataController dataController = Get.put(ListDataController());
  DateTime? selectedDate;
  DateTime? selectedDateCheque; // Variable to store the selected dat
  String? dateText;
  String? dateTime;
  bool isLoading = false;
  String? selectedValueOne;
  var selectedValue;
  String? selectedBankAccount;
  final _formKey = GlobalKey<FormState>();

  TextEditingController remarksController = TextEditingController();
  TextEditingController dialogRemarksController = TextEditingController();
  TextEditingController voucherNumberController = TextEditingController();
  TextEditingController dialogCreditController = TextEditingController();
  TextEditingController dialogDebitController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController voucherTypeController = TextEditingController();

  bool creditObsecure = false;
  bool debitObsecure = false;
  GetStorage _box = GetStorage();

  List<DialogAccountNumberDataModel> dialogaccountNumbers = [];
  String? selectedDialogAccountNumber;

  List<ListDetailsModel> listDetails = []; // State variable to store API data

  Future<void> sendUpdateRequest(UpdateVoucherDataModel updateData) async {
    var url = Uri.parse(
        '${ApiService.baseUrl}JournalVoucher/UpdateJVMast');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updateData.toJson()),
    );
    if (response.statusCode == 200) {
      // Parse the response
      var responseData = ResponseDataModel.fromJson(json.decode(response.body));
      // Update the TextFields
      setState(() {
        statusController.text =
            responseData.status == "0" ? "SAVED" : "VERIFIED";
        isLoading = !isLoading;
      });
      Fluttertoast.showToast(
          msg: "Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      debugPrint('Error: ${response.statusCode}');
      setState(() {
        isLoading = !isLoading;
      });
      Fluttertoast.showToast(
          msg: "Failed To Update",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  Future<void> _refreshListDetails() async {
    //await fetchListDetails();
  }

  Future<void> submitData() async {
    if (remarksController.text.isEmpty) {
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
      return; // Return early as validation failed
    }
    String? usid = _box.read('usid').toString().toUpperCase();

    UpdateVoucherDataModel updateData = UpdateVoucherDataModel(
        rmks: remarksController.text.toString(),
        usid: usid,
        srno: voucherNumberController.text.toString());
    await sendUpdateRequest(updateData);
  }

  Future submitDataDilaog(_pkCodeList, BuildContext context) async {
    if (dialogRemarksController.text.isEmpty ||
        _pkCodeList == null ||
        dialogDebitController.text.isEmpty ||
        dialogCreditController.text.isEmpty) {
      // if (dialogvoucherAmountController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return true; // Return early as validation failed
    } else {
      String fkMastValueDialog = _pkCodeList;
      debugPrint('Voucher No: ${voucherNumberController.text.toString()}');
      debugPrint('Account No: $fkMastValueDialog');
      debugPrint('Debit: ${dialogDebitController.text.toString()}');
      debugPrint('Credit: ${dialogCreditController.text.toString()}');
      debugPrint('Remarks: ${dialogRemarksController.text.toString()}');

      JournalPostDetailModel postDataDialog = JournalPostDetailModel(
        creditDialog: dialogCreditController.text.toString(),
        debitDialog: dialogDebitController.text.toString(),
        srnoDialog: voucherNumberController.text.toString(),
        fkMastDialog: fkMastValueDialog,
        remksDialog: dialogRemarksController.text.toString(),
      );
      await sendPostRequestJournalDialog(postDataDialog, context);
    }
  }

  Future<List<ListDetailsModel>> fetchListDetails() async {
    String srno = voucherNumberController.text;
    // String srno = "2024-01-BPV-0040";
    debugPrint('Voucher Number this time is : ${voucherNumberController.text}');
    var url = Uri.parse(
        '${ApiService.baseUrl}FinancialVoucher/GetListDtl?srno=$srno');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => ListDetailsModel.fromJson(data))
          .toList();
    } else {
      debugPrint('Failed to load list details');
      throw Exception('Failed to load list details');
    }
  }

  Future deleteRecord(String srno, int trno) async {
    var deleteUrl = Uri.parse(
        '${ApiService.baseUrl}PaymentVoucher/DeleteDetailVoucher?srno=$srno&trno=$trno');
    var response = await http.get(deleteUrl);

    if (response.statusCode == 200) {
      // Handle successful deletion
      Fluttertoast.showToast(msg: "Record Deleted Successfully");
      return response;
    } else {
      // Handle failure
      Fluttertoast.showToast(msg: "Failed to delete record");
      return null;
    }
  }

  String? _pkCodeList;
  String? _dialogAccountValue = "Select Account";
  List<String>? accountDialogList = [];
  List<String> pkCodesDialog = [];

  void resetFields() {
    remarksController.clear();
    dialogRemarksController.clear();
    voucherNumberController.clear();
    dialogCreditController.clear();
    dialogDebitController.clear();
    statusController.clear();
    selectedValueOne = null;
    selectedBankAccount = null;
    selectedDialogAccountNumber = null;
    dialogaccountNumbers.clear();
  }

  void resetDialogFields() {
    dialogRemarksController.clear();
    dialogDebitController.clear();
    dialogCreditController.clear();
    selectedDialogAccountNumber = null;
    dialogaccountNumbers.clear();
    _dialogAccountValue = "Select Account";
  }

  fetchListAccounts() async {
    try {
      final data = await ApiService.get("FinancialVoucher/GetAllAccount");
      //debugPrint('Data: $data');
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("NAME") &&
            item.containsKey("PKCODE") &&
            item["NAME"] is String &&
            item["PKCODE"] is String) {
          String name = item['NAME'];
          String pkCode = item['PKCODE'];
          if (!menuItems.contains(name) || !pkCodesDialog.contains(pkCode)) {
            menuItems.add(name);
            debugPrint('OKKKKKKKKK');
            pkCodesDialog.add(pkCode);
          }
        }
      }
      setState(() {
        accountDialogList = menuItems;

        //accountDialogList = menuItems;
        debugPrint('Dialog Accounts: $accountDialogList');
        isLoading = false;
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  Future<void> openDialog(BuildContext context) async {
    if (voucherNumberController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Center(
                child: Text(
              'Journal Voucher Details',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            )),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const SizedBox(height: 10),
                  Text(
                    ' Account No:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.blueGrey.shade600, width: 2.0)),
                    child: DropdownSearch<String>(
                      dropdownBuilder: (context, selectedItem) {
                        return Text(
                          selectedItem.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        );
                      },
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: true,
                      ),
                      items: accountDialogList ?? [],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                            iconColor: Colors.black,
                            isDense: true,
                            hintText: "Search here",
                            hintStyle: TextStyle(color: Colors.black)),
                      ),
                      selectedItem: _dialogAccountValue,
                      onChanged: (value) {
                        setState(() {
                          _dialogAccountValue = value;
                          debugPrint("Account Name: $_dialogAccountValue");

                          _pkCodeList =
                              pkCodesDialog[accountDialogList!.indexOf(value!)];
                          debugPrint("pkcode: $_pkCodeList");
                        });
                      },
                      validator: (value) {
                        if (value == "Select Account") {
                          return "Please select an Account ID";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Debit:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: dialogDebitController,
                              keyboardType: TextInputType.number,
                              readOnly: dialogCreditController.text.isEmpty
                                  ? dialogCreditController.text == '0'
                                      ? true
                                      : false
                                  : false,
                              decoration: InputDecoration(
                                  isDense: true,
                                  prefix: const Padding(
                                      padding: EdgeInsets.only(left: 8)),
                                  enabled: true,
                                  hintText: "Debit Amt",
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
                                setState(() {
                                  if (value.isEmpty) {
                                    dialogCreditController.clear;
                                  } else {
                                    dialogCreditController.text = '0';
                                  }
                                });
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
                              ' Credit:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: dialogCreditController,
                              keyboardType: TextInputType.number,
                              readOnly: dialogDebitController.text.isEmpty
                                  ? dialogDebitController.text == '0'
                                      ? true
                                      : false
                                  : false,
                              decoration: InputDecoration(
                                  isDense: true,
                                  prefix: const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  enabled: true,
                                  hintText: "Credit Amt",
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
                                setState(() {
                                  if (value == '') {
                                    dialogDebitController.clear();
                                  } else {
                                    dialogDebitController.text = '0';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    ' Remarks:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    validator: (dialogremarks) =>
                        dialogremarks!.isEmpty ? " " : null,
                    controller: dialogRemarksController,
                    decoration: InputDecoration(
                        isDense: true,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 08),
                        ),
                        enabled: true,
                        hintText: "Enter Remarks...",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.blueGrey.shade600, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.red.shade600, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Colors.blueGrey.shade600, width: 2.0),
                        )),
                  ),
                ],
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
                          // Background color
                          foregroundColor: Colors.white,
                          // Text color
                          shadowColor: Colors.black,
                          elevation: 2.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(08.0),
                          ),
                        ),
                        child: const Text('Save & Close'),
                        onPressed: () async {
                          await submitDataDilaog(_pkCodeList, context);
                          await fetchListDetails();
                          //Navigator.of(context).pop();
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
                          borderRadius: BorderRadius.circular(08.0),
                        ),
                      ),
                      child: const Text('Cancel'),
                      onPressed: () {
                        // Add your onPressed code here
                        Navigator.of(context).pop(); // Closes the dialog
                      },
                    ),
                  ],
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );
    } else {
      Fluttertoast.showToast(
          msg: "Save The Voucher Details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchListDetails(); // Fetch data when the widget is initialized
    resetFields();
    voucherNumberController.text = widget.srno;
    statusController.text = widget.status;
    remarksController.text = widget.remarks;
    dateTime = widget.vdt;
    dateText = dateTime!.split('T')[0];
    fetchListAccounts();
  }

  @override
  void dispose() {
    searchController.dispose();
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
          'Journal Invoice',
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
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 1,
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
                                            padding: EdgeInsets.only(left: 8),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                          'Voucher Type',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      TextField(
                                        controller: voucherTypeController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          prefix: const Padding(
                                            padding: EdgeInsets.only(left: 8),
                                          ),
                                          filled: true,
                                          enabled: false,
                                          hintText: "JVE",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          fillColor: Colors.grey.shade300,
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
                                const SizedBox(
                                  width: 05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5.0),
                                      child: Text(
                                        'Voucher Date',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF022F8E)),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.blueGrey.shade600,
                                              width: 2.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              dateText == null ? '' : dateText!,
                                              // Display the selected date or "Select Voucher Date"
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Icon(Icons.calendar_month_outlined,
                                                color: Colors.orange)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
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
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        submitData();
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: InkWell(
                    onTap: () {
                      resetDialogFields();
                      openDialog(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/the_plus.png',
                          width: 40,
                          height: 40,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
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
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(08),
                          topRight: Radius.circular(08),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.92,
                                  height: 54,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orangeAccent.shade200),
                                  child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Account Title',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          Text(
                                            'Debit / Credit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                                future: dataController.fetchPaymentListDetails(
                                    voucherNumberController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: Text("Loading Data..."));
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          left: 8,
                                                          right: 8),
                                                  child: Slidable(
                                                    endActionPane: ActionPane(
                                                      extentRatio: 2 / 5,
                                                      motion:
                                                          const DrawerMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (context) {
                                                            String?
                                                                currentSrno =
                                                                voucherNumberController
                                                                    .text;
                                                            debugPrint(
                                                                '$currentSrno');
                                                            var currentTrno =
                                                                dataController
                                                                    .data[index]
                                                                    .trno;
                                                            var damount =
                                                                dataController
                                                                    .data[index]
                                                                    .debitAmount;
                                                            var camount =
                                                                dataController
                                                                    .data[index]
                                                                    .creditAmount;
                                                            var remarks =
                                                                dataController
                                                                    .data[index]
                                                                    .finalRemarks;
                                                            var acc =
                                                                dataController
                                                                    .data[index]
                                                                    .fkmast;

                                                            debugPrint(
                                                                '$currentTrno');
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return MyDialog(
                                                                      srno:
                                                                          currentSrno,
                                                                      trno:
                                                                          currentTrno,
                                                                      accNo:
                                                                          acc,
                                                                      dAmount:
                                                                          damount,
                                                                      cAmount:
                                                                          camount,
                                                                      remarks:
                                                                          remarks);
                                                                });
                                                          },
                                                          backgroundColor:
                                                              Colors.green,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons
                                                              .edit_outlined,
                                                        ),
                                                        SlidableAction(
                                                          onPressed: (context) {
                                                            String?
                                                                currentSrno =
                                                                voucherNumberController
                                                                    .text;
                                                            debugPrint(
                                                                '$currentSrno');
                                                            var currentTrno =
                                                                dataController
                                                                    .data[index]
                                                                    .trno;
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
                                                                  bottomRight:
                                                                      Radius.circular(
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
                                                              0.95,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: index %
                                                                      2 ==
                                                                  0
                                                              ? Colors.blueGrey
                                                                  .shade50
                                                              : Colors.blue
                                                                  .shade50),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5.0,
                                                                  right: 5.0),
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
                                                                      "${dataController.data[index].accholder}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      '${dataController.data[index].debitAmount ?? "0"}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      '${dataController.data[index].creditAmount ?? "0"}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Remarks : ${dataController.data[index].finalRemarks ?? "N/A"}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
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
                                                child:
                                                    Text("No data found!"))));
                                  }
                                }),
                            const SizedBox(height: 8)
                          ],
                        ),
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

class MyDialog extends StatefulWidget {
  var srno;
  var trno;
  var accNo;
  var dAmount;
  var cAmount;
  var remarks;

  MyDialog(
      {this.trno,
      required this.srno,
      required this.accNo,
      required this.dAmount,
      required this.cAmount,
      required this.remarks});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final ListDataController dataController = Get.put(ListDataController());

  TextEditingController dialogRemarksController = TextEditingController();
  TextEditingController voucherNumberController = TextEditingController();
  TextEditingController dialogDebitController = TextEditingController();
  TextEditingController dialogCreditController = TextEditingController();

  bool btn = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  var trno;
  String? _pkCodeList;
  String? _dialogAccountValue = " Select Account";
  List<String>? accountDialogList = [];
  List<String> pkCodesDialog = [];
  var selectedPKCODE;

  fetchListAccounts() async {
    try {
      final data = await ApiService.get("FinancialVoucher/GetAllAccount");
      //debugPrint('Data: $data');
      List<String> menuItems = [];

      for (var item in data) {
        if (item is Map<String, dynamic> &&
            item.containsKey("NAME") &&
            item.containsKey("PKCODE") &&
            item["NAME"] is String &&
            item["PKCODE"] is String) {
          String name = item['NAME'];
          String pkCode = item['PKCODE'];
          if (!menuItems.contains(name) || !pkCodesDialog.contains(pkCode)) {
            menuItems.add(name);
            debugPrint('OKKKKKKKKK');
            pkCodesDialog.add(pkCode);
          }
        }
      }
      setState(() {
        accountDialogList = menuItems;
        int selectedIndex = pkCodesDialog.indexOf(selectedPKCODE);
        String accountName = accountDialogList![selectedIndex];
        _dialogAccountValue = accountName;
        _pkCodeList =
            pkCodesDialog[accountDialogList!.indexOf(_dialogAccountValue!)];
        debugPrint('Menu Items: $menuItems');
        //accountDialogList = menuItems;
        debugPrint('Dialog Accounts: $accountDialogList');
        isLoading = false;
      });
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  Future updateDataDialog(String? pkCodeList, BuildContext context) async {
    if (voucherNumberController.text.isNotEmpty &&
        trno.toString().isNotEmpty &&
        dialogRemarksController.text.isNotEmpty &&
        pkCodeList!.isNotEmpty) {
      try {
        var url = Uri.parse(
            '${ApiService.baseUrl}JournalVoucher/UpdateDetailVoucher');

        Map<String, dynamic> body = {
          "SRNO": '${voucherNumberController.text.toString()}',
          "TRNO": '$trno',
          "FKMAST": '$pkCodeList',
          "AMNTD": '${dialogDebitController.text}',
          "AMNTC": '${dialogCreditController.text}',
          "RMKS": '${dialogRemarksController.text.toString()}'
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
            dataController
                .fetchPaymentListDetails(voucherNumberController.text);
          });
          Get.back();
          //Navigator.of(context).pop("${fetchListDetails()}");
          Fluttertoast.showToast(
              msg: "Data Updated Successfully",
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
              msg: "Failed To Update Record",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voucherNumberController.text = widget.srno;
    trno = widget.trno;
    selectedPKCODE = widget.accNo;
    dialogRemarksController.text = widget.remarks;
    dialogDebitController.text = widget.dAmount.toString();
    dialogCreditController.text = widget.cAmount.toString();
    fetchListAccounts();
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
        'Journal Voucher Details',
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
      )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              ' Account No:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blueGrey.shade600, width: 2.0)),
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
                  showSearchBox: true,
                ),
                items: accountDialogList ?? [],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      iconColor: Colors.black,
                      isDense: true,
                      hintText: "Search here",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                selectedItem: _dialogAccountValue,
                onChanged: (value) {
                  setState(() {
                    _dialogAccountValue = value;
                    debugPrint("Account Name: $_dialogAccountValue");

                    _pkCodeList =
                        pkCodesDialog[accountDialogList!.indexOf(value!)];
                    debugPrint("pkcode: $_pkCodeList");
                  });
                },
                validator: (value) {
                  if (value == "Select Account") {
                    return "Please select an Account ID";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Debit:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: dialogDebitController,
                        keyboardType: TextInputType.number,
                        readOnly: dialogCreditController.text.isEmpty
                            ? dialogCreditController.text == '0'
                                ? true
                                : false
                            : false,
                        decoration: InputDecoration(
                            isDense: true,
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 08),
                            ),
                            enabled: true,
                            hintText: "Debit Amt",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            fillColor: Colors.grey.shade200,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blueGrey.shade600, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blueGrey.shade600, width: 2.0),
                            )),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              dialogCreditController.clear;
                            } else {
                              dialogCreditController.text = '0';
                            }
                          });
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
                        ' Credit:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: dialogCreditController,
                        keyboardType: TextInputType.number,
                        readOnly: dialogDebitController.text.isEmpty
                            ? dialogDebitController.text == '0'
                                ? true
                                : false
                            : false,
                        decoration: InputDecoration(
                            isDense: true,
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            enabled: true,
                            hintText: "Credit Amt",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            fillColor: Colors.grey.shade200,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blueGrey.shade600, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blueGrey.shade600, width: 2.0),
                            )),
                        onChanged: (value) {
                          setState(() {
                            if (value == '') {
                              dialogDebitController.clear();
                            } else {
                              dialogDebitController.text = '0';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              ' Remarks:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              validator: (dialogremarks) => dialogremarks!.isEmpty ? " " : null,
              controller: dialogRemarksController,
              decoration: InputDecoration(
                  isDense: true,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 08),
                  ),
                  enabled: true,
                  hintText: "Enter Remarks...",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  fillColor: Colors.grey.shade200,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade600, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.red.shade600, width: 2.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade600, width: 2.0),
                  )),
            ),
          ],
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
                      borderRadius: BorderRadius.circular(08.0),
                    ),
                  ),
                  child: const Text('Update & Close'),
                  onPressed: () async {
                    await updateDataDialog(_pkCodeList, context);
                    dataController
                        .fetchPaymentListDetails(voucherNumberController.text);
                    //await fetchListDetails();
                    //Navigator.of(context).pop();
                  }),
              const SizedBox(width: 20), // Spacing between buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red.shade400,
                  shadowColor: Colors.black,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(08.0),
                  ),
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  // Add your onPressed code here
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
