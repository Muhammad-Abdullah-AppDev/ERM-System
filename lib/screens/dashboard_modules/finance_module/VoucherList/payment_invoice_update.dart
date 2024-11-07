import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../../../../controllers/invoices_listDtl_controller.dart';
import '../../../../models/bank_account_number_model.dart';
import '../../../../models/cash_account_number_model.dart';
import '../../../../models/dialog_post_data_model.dart';
import '../../../../models/get_account_no_dialog.dart';
import '../../../../models/list_details_model.dart';
import '../../../../models/response_data_model.dart';
import '../../../../models/update_voucherData_model.dart';
import '../../../../services/api_service.dart';
import '../../../../services/create_vc_api.dart';

class PaymentInvoiceUpdate extends StatefulWidget {
  var srno;
  var status;
  var vcType;
  var remarks;
  var vdt;
  var chqNo;
  var chqDt;
  var accNo;

  PaymentInvoiceUpdate(
      {super.key,
        required this.srno,
        required this.status,
        required this.vcType,
        required this.remarks,
        required this.vdt,
        this.chqNo,
        this.chqDt,
        required this.accNo});

  @override
  State<PaymentInvoiceUpdate> createState() => _PaymentInvoiceUpdateState();
}

class _PaymentInvoiceUpdateState extends State<PaymentInvoiceUpdate> {

  final ListDataController dataController = Get.put(ListDataController());
  DateTime? selectedDate;
  DateTime? selectedDateCheque; // Variable to store the selected dat

  bool isLoading = false;
  String? selectedValueOne;
  String? dateText;
  String? dateTextCheque;
  String? dateTimeChq;
  String? dateTime;
  var selectedValue;
  final _formKey = GlobalKey<FormState>();

  TextEditingController remarksController = TextEditingController();
  TextEditingController dialogRemarksController = TextEditingController();
  TextEditingController voucherNumberController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();
  TextEditingController dialogvoucherAmountController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  GetStorage _box = GetStorage();

  List<BankBalanceAccountNumberModel> bankaccountNumbers = [];
  String? selectedBankAccountNumber;

  List<CashBalanceAccountNumberModel> cashAccountNumbers = [];
  String? selectedCashAccountNumber;

  List<DialogAccountNumberDataModel> dialogaccountNumbers = [];
  String? selectedDialogAccountNumber;

  List<ListDetailsModel> listDetails = []; // State variable to store API data

  final List<String> itemsOne = ['Bank Voucher', 'Cash Voucher'];

  Future<void> sendUpdateRequest(UpdateVoucherDataModel updateData) async {
    setState(() {
      isLoading = !isLoading;
    });
    debugPrint("DATA: ${updateData.toJson()}");
    var url = Uri.parse(
        '${ApiService.baseUrl}PaymentVoucher/UpdatePayMast');
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

      Fluttertoast.showToast(
          msg: "Record Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 15.0);
      // Update the TextFields
      setState(() {
        //voucherNumberController.text = responseData.serialno ?? "N/A";
        statusController.text =
        responseData.status == "0" ? "SAVED" : "VERIFIED";
        isLoading = !isLoading;
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.body}');
      setState(() {
        isLoading = !isLoading;
      });
      Fluttertoast.showToast(
          msg: "Failed To Update Record",
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

  Future<void> _selectDateNew() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != selectedDateCheque) {
      setState(() {
        selectedDateCheque = pickedDate;
        dateTextCheque =
            DateFormat('dd-MM-yyyy').format(selectedDateCheque!).toUpperCase();
      });
    }
  }

  Future<void> submitData() async {
    // Validation checks
    if (selectedValueOne == null ||
        remarksController.text.isEmpty ||
        _accountValue == null) {
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return; // Return early as validation failed
    }

    String? fkMastValue = _pkCode;

    String formattedDateCheque = selectedDateCheque != null
        ? DateFormat('dd-MM-yyyy').format(selectedDateCheque!).toUpperCase()
        : '';
    //String? voucherType = selectedValueOne == 'Bank Voucher' ? 'BPV' : 'CPV';
    String? usid = _box.read('usid').toString().toUpperCase();

    UpdateVoucherDataModel UpdateData = UpdateVoucherDataModel(
      fkMast: fkMastValue,
      chqNO: chequeNumberController.text.toString(),
      chqDT: formattedDateCheque,
      rmks: remarksController.text.toString(),
      usid: usid,
      srno: voucherNumberController.text.toString(),
    );
    await sendUpdateRequest(UpdateData);
    debugPrint('fkMast is : $fkMastValue');
    debugPrint('USID is : $usid');
    debugPrint('Voucher No : ${voucherNumberController.text.toString()}');
    debugPrint('Cheque No : ${chequeNumberController.text.toString()}');
    debugPrint('Cheque Date : $dateTextCheque');
  }

  Future submitDataDilaog(_pkCodeList) async {
    if (dialogvoucherAmountController.text.isEmpty ||
        dialogRemarksController.text.isEmpty ||
        _pkCodeList == null) {
      // if (dialogvoucherAmountController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "All Fields are Required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow.shade800,
          textColor: Colors.white,
          fontSize: 15.0);
      return true; // Return early as validation failed
    } else {
      String fkMastValueDialog = _pkCodeList;

      PostDataModelDialog postDataDialog = PostDataModelDialog(
        theamountDialog: dialogvoucherAmountController.text,
        srnoDialog: voucherNumberController.text,
        fkMastDialog: fkMastValueDialog,
        remksDialog: dialogRemarksController.text,
      );
      await sendPostRequestPaymentDialog(postDataDialog, context);
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

  String? _pkCode;
  String? _pkCodeList;
  String? _accountValue = " Select Account";
  String? _dialogAccountValue = "Select Account";
  List<String>? accountBankList = [];
  List<String>? accountCashList = [];
  List<String>? accountDialogList = [];
  List<String> pkCodesBank = [];
  List<String> pkCodesCash = [];
  List<String> pkCodesDialog = [];
  var selectedPKCODE;

  Future<void> onVoucherTypeChanged(String? newValue) async {
    if (newValue == 'Bank Voucher') {
      try {
        final data = await ApiService.get("Balances/BankBalance");
        List<String> menuItems = [];

        for (var item in data) {
          if (item is Map<String, dynamic> &&
              item.containsKey("NAME") &&
              item.containsKey("PKCODE") &&
              item["NAME"] is String &&
              item["PKCODE"] is String) {
            String name = item['NAME'];
            String pkCode = item['PKCODE'];
            if (!menuItems.contains(name) && !pkCodesBank.contains(pkCode)) {
              menuItems.add(name);
              pkCodesBank.add(pkCode);
            }
          }
        }

        setState(() {
          accountBankList = menuItems;
          int selectedIndex = pkCodesBank.indexOf(selectedPKCODE);
          String accountName = accountBankList![selectedIndex];
          _accountValue = accountName;
          _pkCode = pkCodesBank[accountBankList!.indexOf(_accountValue!)];
          //debugPrint('Bank Accounts: $accountBankList');
          debugPrint('Selected Account: $_accountValue');
          debugPrint('Selected pkCode: $_pkCode');
          isLoading = false;
        });
      } catch (e) {
        debugPrint("An error occurred: $e");
      }
    } else if (newValue == 'Cash Voucher') {
      try {
        final data = await ApiService.get("Balances/CashBalance");
        List<String> menuItems = [];

        for (var item in data) {
          if (item is Map<String, dynamic> &&
              item.containsKey("NAME") &&
              item.containsKey("PKCODE") &&
              item["NAME"] is String &&
              item["PKCODE"] is String) {
            String name = item['NAME'];
            String pkCode = item['PKCODE'];
            if (!menuItems.contains(name) && !pkCodesCash.contains(pkCode)) {
              menuItems.add(name);
              pkCodesCash.add(pkCode);
            }
          }
        }

        setState(() {
          accountCashList = menuItems;
          int selectedIndex = pkCodesCash.indexOf(selectedPKCODE);
          String accountName = accountCashList![selectedIndex];
          _accountValue = accountName;
          _pkCode = pkCodesCash[accountCashList!.indexOf(_accountValue!)];
          debugPrint('Cash Accounts: $accountCashList');
          isLoading = false;
        });
      } catch (e) {
        debugPrint("An error occurred: $e");
      }
    }
  }

  void resetFields() {
    // Resetting TextControllers
    remarksController.clear();
    dialogRemarksController.clear();
    voucherNumberController.clear();
    dialogvoucherAmountController.clear();
    statusController.clear();
    // Resetting other variables (dropdowns, lists, etc.)
    selectedValueOne = null;
    selectedBankAccountNumber = null;
    selectedCashAccountNumber = null;
    selectedDialogAccountNumber = null;
    bankaccountNumbers.clear();
    cashAccountNumbers.clear();
    dialogaccountNumbers.clear();
  }

  void resetDialogFields() {
    // Resetting TextControllers
    dialogRemarksController.clear();
    dialogvoucherAmountController.clear();
    // Resetting other variables (dropdowns, lists, etc.)
    selectedDialogAccountNumber = null;
    dialogaccountNumbers.clear();
  }

  Future<void> openDialog(BuildContext context) async {
    if (voucherNumberController.text.isNotEmpty) {
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
          debugPrint('Menu Items: $menuItems');
          accountDialogList = menuItems;
          debugPrint('Dialog Accounts: $accountDialogList');
          isLoading = false;
        });
      } catch (e) {
        debugPrint("An error occurred: $e");
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Center(
                    child: Text(
                      'Payment Voucher Details',
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
                      Text(
                        ' Amount:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: dialogvoucherAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            isDense: true,
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 08),
                            ),
                            enabled: true,
                            hintText: "Amount",
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
                              await submitDataDilaog(_pkCodeList);
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
            });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Optionally preload data if required
    //fetchListDetails(); // Fetch data when the widget is initialized
    resetFields();
    voucherNumberController.text = widget.srno;
    statusController.text = widget.status;
    widget.vcType == 'BPV'
        ? selectedValueOne = 'Bank Voucher'
        : selectedValueOne = 'Cash Voucher';
    dateTimeChq = widget.chqDt;
    dateTimeChq == null
        ? dateTextCheque = ''
        : dateTextCheque = dateTimeChq!.split('T')[0];
    dateTime = widget.vdt;
    dateText = dateTime!.split('T')[0];
    remarksController.text = widget.remarks;
    chequeNumberController.text = widget.chqNo;
    selectedPKCODE = widget.accNo;
    onVoucherTypeChanged(selectedValueOne);
  }

  @override
  void dispose() {
    //searchController.dispose();
    debugPrint('Disposed Called..........');
    dataController.dispose();
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
          'Payment Invoice',
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
                      top: 4, left: 8, right: 8, bottom: 5),
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
                                    padding:
                                    const EdgeInsets.only(right: 20.0),
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
                                                padding:
                                                EdgeInsets.only(left: 8),
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
                                                color:
                                                Colors.blueGrey.shade600,
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
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.46,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.blueGrey.shade600,
                                              width: 2.0)),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              selectedValueOne!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Column(
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
                                              dateText == null
                                                  ? ''
                                                  : dateText!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.orange,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (selectedValueOne == 'Bank Voucher')
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  //cheque Number
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          child: Text(
                                            'Cheque Number',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF022F8E)),
                                          ),
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: chequeNumberController,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              prefix: const Padding(
                                                padding:
                                                EdgeInsets.only(left: 08),
                                              ),
                                              enabled: true,
                                              hintText: "Cheque Number",
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              fillColor: Colors.grey.shade200,
                                              enabledBorder:
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5),
                                        child: Text(
                                          'Cheque Date',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF022F8E)),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            border: Border.all(
                                                color:
                                                Colors.blueGrey.shade600,
                                                width: 2.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              dateTextCheque == null
                                                  ? ''
                                                  : dateTextCheque!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  _selectDateNew();
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .calendar_month_outlined,
                                                  color: Colors.orange,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            Visibility(
                              visible: selectedValueOne == 'Bank Voucher',
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
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
                                            'Account Number',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF022F8E)),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors
                                                      .blueGrey.shade600,
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
                                            items: accountBankList ?? [],
                                            dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                              InputDecoration(
                                                iconColor: Colors.black,
                                                isDense: true,
                                                hintText:
                                                "Search here", // Set the hint text
                                              ),
                                            ),
                                            selectedItem: _accountValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _accountValue = value;
                                                debugPrint(
                                                    "Account Name..$_accountValue");

                                                _pkCode = pkCodesBank[
                                                accountBankList!
                                                    .indexOf(value!)];
                                                debugPrint(
                                                    "pkcode..$_pkCode");
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
                                ],
                              ),
                            ),
                            Visibility(
                              visible: selectedValueOne == 'Cash Voucher',
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
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
                                            'Account Number',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF022F8E)),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors
                                                      .blueGrey.shade600,
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
                                            items: accountCashList ?? [],
                                            dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                              InputDecoration(
                                                iconColor: Colors.black,
                                                isDense: true,
                                                hintText:
                                                "Search here", // Set the hint text
                                              ),
                                            ),
                                            selectedItem: _accountValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _accountValue = value;
                                                debugPrint(
                                                    "Account Name..$_accountValue");

                                                _pkCode = pkCodesCash[
                                                accountCashList!
                                                    .indexOf(value!)];
                                                debugPrint(
                                                    "pkcode..$_pkCode");
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
                                ],
                              ),
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
                                                color:
                                                Colors.blueGrey.shade600,
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
                                                color:
                                                Colors.blueGrey.shade600,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
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
                  padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 5),
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
                                width:
                                MediaQuery.of(context).size.width * 0.9,
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
                                          'Debit',
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
                                          padding: const EdgeInsets.only(
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
                                                    String? currentSrno =
                                                        voucherNumberController
                                                            .text;
                                                    debugPrint('$currentSrno');
                                                    var currentTrno =
                                                        dataController
                                                            .data[index].trno;
                                                    var amount =
                                                        dataController
                                                            .data[index]
                                                            .debitAmount;
                                                    var remarks =
                                                        dataController
                                                            .data[index]
                                                            .finalRemarks;
                                                    var acc = dataController
                                                        .data[index].fkmast;

                                                    debugPrint('$currentTrno');
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context)
                                                        { return MyDialog(
                                                            srno: currentSrno,
                                                            trno: currentTrno,
                                                            accNo: acc,
                                                            amount: amount,
                                                            remarks: remarks);
                                                        });
                                                  },
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit_outlined,
                                                ),

                                                SlidableAction(
                                                  onPressed: (context) {
                                                    String? currentSrno =
                                                        voucherNumberController
                                                            .text;
                                                    debugPrint('$currentSrno');
                                                    var currentTrno =
                                                        dataController
                                                            .data[index].trno;
                                                    debugPrint('$currentTrno');
                                                    showDeleteDialog(
                                                        context,
                                                        currentSrno,
                                                        currentTrno);
                                                  },
                                                  borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                      Radius.circular(
                                                          10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          10)),
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons
                                                      .delete_outline_rounded,
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.9,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: index % 2 == 0
                                                      ? Colors.blueGrey.shade50
                                                      : Colors.blue.shade50),
                                              child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(
                                                            (dataController.data[index]
                                                                .accholder ??
                                                                "N/A"),
                                                            style:
                                                            const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${dataController.data[index].debitAmount ?? "N/A"}',
                                                            style:
                                                            const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
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

class MyDialog extends StatefulWidget {
  var srno;
  var trno;
  var accNo;
  var amount;
  var remarks;

  MyDialog(
      {this.trno,
        required this.srno,
        required this.accNo,
        required this.amount,
        required this.remarks});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  final ListDataController dataController = Get.put(ListDataController());

  TextEditingController dialogRemarksController = TextEditingController();
  TextEditingController voucherNumberController = TextEditingController();
  TextEditingController dialogvoucherAmountController = TextEditingController();

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
          _pkCodeList = pkCodesDialog[accountDialogList!.indexOf(_dialogAccountValue!)];
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
        dialogvoucherAmountController.text.isNotEmpty &&
        dialogRemarksController.text.isNotEmpty &&
        pkCodeList!.isNotEmpty) {
      try {
        var url = Uri.parse(
            '${ApiService.baseUrl}PaymentVoucher/UpdateDetailVoucher');

        Map<String, dynamic> body = {
          "SRNO": '${voucherNumberController.text.toString()}',
          "TRNO": '$trno',
          "FKMAST": '$pkCodeList',
          "AMNTD": '${dialogvoucherAmountController.text}',
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
            dataController.fetchPaymentListDetails(voucherNumberController.text);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voucherNumberController.text = widget.srno;
    trno = widget.trno;
    selectedPKCODE = widget.accNo;
    dialogRemarksController.text = widget.remarks;
    dialogvoucherAmountController.text = widget.amount.toString();
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
            'Payment Voucher Details',
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
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  );
                },
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true
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
            Text(
              ' Amount:',
              style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: dialogvoucherAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 08),
                  ),
                  enabled: true,
                  hintText: "Amount",
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
                  prefix: const Padding(padding: EdgeInsets.only(left: 8)),
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
                    borderSide:
                    BorderSide(color: Colors.red.shade600, width: 2.0),
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
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 2.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(08.0),
                    ),
                  ),
                  child: Text("Update & Close"),
                  onPressed: () async {
                    updateDataDialog(_pkCodeList, context);
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
                  Navigator.of(context).pop();
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