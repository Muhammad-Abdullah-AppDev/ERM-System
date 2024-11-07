import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:scarlet_erm/screens/dashboard_modules/sales_module/invoice_preview.dart';
import 'package:scarlet_erm/screens/dashboard_modules/sales_module/sales_invoice_update.dart';
import 'package:scarlet_erm/services/api_service.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/sales_vcList_model.dart';

class SalesVoucherScreen extends StatefulWidget {
  final Future<List<SalesVcListModel>> dataFutureSales;

  SalesVoucherScreen({required this.dataFutureSales});
  @override
  _SalesVoucherScreenState createState() => _SalesVoucherScreenState();
}

class _SalesVoucherScreenState extends State<SalesVoucherScreen> {
  int totalBalance = 0;
  int? selectedOption;
  var srno;
  var status;
  var customer;
  var vdt;
  var remarks;
  var usid;

  String dropdownValue = 'Saved';
  String _selectedMonth =
      DateFormat('MMM').format(DateTime.now()).toUpperCase();
  String? voucherType;
  late String selectedMonthValue;
  bool isLoading = false;

  late Future<List<SalesVcListModel>> _dataFutureSales;

  @override
  void initState() {
    super.initState();
    GetStorage _box = GetStorage();
    usid = _box.read('usid');
    _dataFutureSales = widget.dataFutureSales;
    selectedMonthValue = getMonthValue();
    _dataFutureSales =
        ApiService().getSalesVouchers("DirectSaleInvoice/getVoucherList");
  }

  String getMonthValue() {
    if (_selectedMonth == "JAN") {
      return selectedMonthValue = "01";
    } else if (_selectedMonth == "FEB") {
      return selectedMonthValue = "02";
    } else if (_selectedMonth == "MAR") {
      return selectedMonthValue = "03";
    } else if (_selectedMonth == "APR") {
      return selectedMonthValue = "04";
    } else if (_selectedMonth == "MAY") {
      return selectedMonthValue = "05";
    } else if (_selectedMonth == "JUN") {
      return selectedMonthValue = "06";
    } else if (_selectedMonth == "JUL") {
      return selectedMonthValue = "07";
    } else if (_selectedMonth == "AUG") {
      return selectedMonthValue = "08";
    } else if (_selectedMonth == "SEP") {
      return selectedMonthValue = "09";
    } else if (_selectedMonth == "OCT") {
      return selectedMonthValue = "10";
    } else if (_selectedMonth == "NOV") {
      return selectedMonthValue = "11";
    } else if (_selectedMonth == "DEC") {
      return selectedMonthValue = "12";
    }
    return selectedMonthValue;
  }

  String formatDate(String? date) {
    if (date != null) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }
    return '';
  }

  Widget buildVoucherList(
    List<SalesVcListModel> vouchers,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: vouchers.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.transparent),
        itemBuilder: (context, index) {
          SalesVcListModel voucher = vouchers[index];
          return Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return VoucherDialog(
                            voucher.sRNO,
                            formatDate(voucher.vDT),
                            voucher.rMKS,
                            voucher.cUSTNAME,
                            voucher.sOSTATUS,
                            voucher.fKFSCD);
                      },
                    );
                  },
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor:
                        index.isEven ? Colors.blue[50] : Colors.blueGrey[50],
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${voucher.sRNO}   ${voucher.vDT != null ? formatDate(voucher.vDT) : ''}",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${voucher.cUSTNAME}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        Text(
                          "Rmks: ${voucher.rMKS != null ? (dropdownValue == 'Saved' ? (voucher.rMKS!.length > 22 ? '${voucher.rMKS!.substring(0, 21)}...' : voucher.rMKS) : (voucher.rMKS!.length > 22 ? '${voucher.rMKS!.substring(0, 21)}...' : voucher.rMKS)) : ''}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    trailing: dropdownValue == 'Saved'
                        ? InkWell(
                            onTap: () async {
                              debugPrint("Voucher No: ${voucher.sRNO}");
                              srno = voucher.sRNO;
                              status = voucher.sOSTATUS;
                              customer = voucher.fKFSCD;
                              vdt = voucher.vDT;
                              remarks = voucher.rMKS;

                              debugPrint(
                                  "Values: $srno, $status, $customer, $vdt, $remarks");
                              Get.to(
                                SalesInvoiceUpdate(
                                    srno: srno,
                                    status: status,
                                    customer: customer,
                                    vdt: vdt,
                                    remarks: remarks),
                                transition: Transition.leftToRightWithFade,
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    const BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 1,
                                        blurRadius: 6)
                                  ]),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator.adaptive(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.black),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 14),
                                    )),
                            ),
                          )
                        : const Image(
                            image: AssetImage("assets/images/approved.png"),
                            color: Colors.green),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo.shade400,
                    Colors.blue.shade400,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(2.0, 7.0),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            '$dropdownValue',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: <String>['Saved', 'Processed']
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: dropdownValue == item
                                            ? Colors.greenAccent
                                            : Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            newValue == dropdownValue
                                ? null
                                : setState(() {
                                    dropdownValue = newValue!;
                                    getMonthValue();
                                    debugPrint("Status Value: $dropdownValue");
                                  });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 50,
                            width: 102,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                            iconSize: 16,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.white70,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFF04375e),
                            ),
                            offset: const Offset(-25, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 16, right: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            '${_selectedMonth.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          items: <String>[
                            'JAN',
                            'FEB',
                            'MAR',
                            'APR',
                            'MAY',
                            'JUN',
                            'JUL',
                            'AUG',
                            'SEP',
                            'OCT',
                            'NOV',
                            'DEC'
                          ]
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _selectedMonth.toUpperCase() == item
                                                ? Colors.greenAccent
                                                : Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: _selectedMonth.toUpperCase(),
                          onChanged: (String? newValue) {
                            newValue == _selectedMonth
                                ? null
                                : setState(() {
                                    _selectedMonth = newValue!;
                                    getMonthValue();
                                    debugPrint(
                                        "Selected Month: $_selectedMonth");
                                  });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 50,
                            width: 60,
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                            ),
                            iconSize: 16,
                            iconEnabledColor: Colors.white,
                            iconDisabledColor: Colors.grey,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFF04375e),
                            ),
                            offset: const Offset(-25, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 16, right: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<SalesVcListModel>>(
            future: _dataFutureSales,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                      child: SpinKitFadingFour(
                    color: Color(0xFF144b9d),
                    size: 100,
                  )),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              } else {
                List<SalesVcListModel> salesVouchers = snapshot.data!;
                debugPrint(
                    'Total Vouchers: ${salesVouchers.length.toString()}');

                if (dropdownValue == "Saved") {
                  List<SalesVcListModel> savedVouchers = salesVouchers
                      .where((voucher) =>
                          voucher.sOSTATUS == 'Saved' &&
                          voucher.fKMCD == selectedMonthValue)
                      .toList();
                  debugPrint("Vouchers: ${savedVouchers.length}");
                  return savedVouchers.length == 0
                      ? const Center(
                          child: Text(
                          '\n\n\n\n\n\n\nNo Data To Display In Selected Category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ))
                      : buildVoucherList(savedVouchers);
                } else {
                  List<SalesVcListModel> verifiedVouchers = salesVouchers
                      .where((voucher) =>
                          voucher.sOSTATUS == 'Processed' &&
                          voucher.fKMCD == selectedMonthValue)
                      .toList();
                  return verifiedVouchers.length == 0
                      ? const Center(
                          child: Text(
                          '\n\n\n\n\n\n\nNo Data To Display In Selected Category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ))
                      : buildVoucherList(verifiedVouchers);
                }
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ))),
    );
  }

  double previousBal = 0.0;

  Future getPreviousBal(srno) async {
    try {
      final response = await http.get(Uri.parse(
          "${ApiService.baseUrl}DirectSaleInvoice/CustCLBal?srno=$srno"));

      if (response.statusCode == 200) {
        debugPrint('Previous Balance :  ${response.body}');
        previousBal = double.parse(response.body);
        return response.body;
      } else {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response: ${response.body}');

        return null;
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Widget VoucherDialog(String? sRNO, String formatDate, String? rMKS,
      String? cUSTNAME, String? sOSTATUS, String? fKFSCD) {
    return Stack(children: [
      Dialog(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.blueAccent,
        child: Container(
          padding:
              const EdgeInsets.only(top: 80, left: 18, right: 18, bottom: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.blue, width: 4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black87, spreadRadius: 2, blurRadius: 12)
              ]),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serial No:   $sRNO',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _buildDivider(),
                Text(
                  'Date:         $formatDate',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _buildDivider(),
                Text(
                  'Cust: $cUSTNAME',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  overflow: TextOverflow.visible,
                ),
                _buildDivider(),
                Text(
                  'Rmks: $rMKS',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _buildDivider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (sOSTATUS == "Processed") ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(6.0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return Colors.redAccent;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          var responseBody = await voucherDelete(sRNO);

                          if (responseBody != null) {
                            setState(() {
                              isLoading = !isLoading;
                              _dataFutureSales = ApiService().getSalesVouchers(
                                  "DirectSaleInvoice/getVoucherList");
                            });
                            Fluttertoast.showToast(
                              msg: "Voucher Deleted Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            Fluttertoast.showToast(
                              msg: "Failed to Delete Voucher",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(6.0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return isLoading ? Colors.grey : Colors.red;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const Text('Delete'),
                      ),
                    ],
                    if (sOSTATUS == "Processed") ...[
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(6.0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return Colors.grey;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: const Text('Approved'),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          //var responseBody = await voucherApprove(sRNO);
                          var responseBody = ApiService.get(
                              "DirectSaleInvoice/ApproveDSIVoucher?srno=$sRNO&usid=$usid");

                          if (responseBody != null) {
                            setState(() {
                              isLoading = !isLoading;

                              _dataFutureSales = ApiService().getSalesVouchers(
                                  "DirectSaleInvoice/getVoucherList");
                            });
                            Fluttertoast.showToast(
                                msg: "Voucher Approved Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            Fluttertoast.showToast(
                              msg: "Failed to Approve Voucher",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(6.0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return isLoading ? Colors.grey : Colors.green;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text('Approve'),
                      ),
                    ]
                  ],
                ),
                SizedBox(height: 15),
                FutureBuilder(
                  future: getPreviousBal(sRNO),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasError) {
                      debugPrint(snapshot.error.toString());
                      return Center(
                        child: Text('Something went wrong please try later'),
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InvoicePreview(
                                        srno: sRNO,
                                        vdt: formatDate,
                                        rmks: rMKS,
                                        custName: cUSTNAME,
                                        custCode: fKFSCD,
                                        preBal: previousBal)));
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(6.0),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey;
                                }
                                return Colors.blue;
                              },
                            ),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                            shadowColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: const Text('Invoice Preview'),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ]),
        ),
      ),
      Center(
        child: Container(
          width: 110,
          height: 110,
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 3),
              color: Colors.blue),
          child: Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Color(0xff026ca6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/vr2.png'),
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Image.asset(
              "assets/images/vr2.png",
            ),
          ),
          margin: const EdgeInsets.only(bottom: 410),
        ),
      ),
      Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0), color: Colors.grey),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined, size: 35)),
          margin: const EdgeInsets.only(bottom: 380, left: 270),
        ),
      ),
    ]);
  }
}

_buildDivider() {
  return const Divider(
    thickness: 1,
    endIndent: 20,
    indent: 40,
    color: Colors.grey,
  );
}

// Future<String?> voucherApprove(sRNO) async {
//   final String apiUrl =
//       'https://erm.scarletsystems.com:1235/Api/DirectSaleInvoice/ApproveDSIVoucher?SRNO=$sRNO'; // Replace with your API endpoint
//
//   Map<String, dynamic> data = {
//     'SRNO': '$sRNO',
//   };
//
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(data),
//     );
//
//     if (response.statusCode == 200) {
//       debugPrint('Success: ${response.body}');
//       return response.body; // Return the response body on success
//     } else {
//       debugPrint('Error: ${response.statusCode}');
//       debugPrint('Response: ${response.body}');
//     }
//   } catch (e) {
//     debugPrint('Exception during POST request: $e');
//   }
//   // Return null or a default value in case of an error
//   return null;
// }

Future<dynamic> voucherDelete(sRNO) async {
  final String apiUrl =
      '${ApiService.baseUrl}DirectSaleInvoice/DeleteDSIVoucher?srno=$sRNO';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {
      debugPrint('Success: ${response.body}');
      debugPrint('$sRNO');
      return response.body; // Return the response body on success
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
      // Return an error message or throw an exception based on the response status code
      return null;
    }
  } catch (e) {
    debugPrint('Exception during GET request: $e');
    // Return an error message or throw an exception based on the error
    return 'Exception during GET request: $e';
  }
}
