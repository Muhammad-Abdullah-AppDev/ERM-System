import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:scarlet_erm/models/sales_listdtl_model.dart';
import 'package:http/http.dart' as http;
import 'package:scarlet_erm/services/api_service.dart';

import '../../../controllers/invoices_listDtl_controller.dart';

class InvoicePreview extends StatefulWidget {
  var srno;
  var vdt;
  var rmks;
  var custName;
  var custCode;
  var preBal;

  InvoicePreview(
      {super.key,
      required this.srno,
      required this.vdt,
      required this.rmks,
      required this.custName,
      required this.custCode,
      required this.preBal});

  @override
  State<InvoicePreview> createState() => _InvoicePreviewState();
}

class _InvoicePreviewState extends State<InvoicePreview> {
  final ListDataController dataController = Get.put(ListDataController());
  var srno;
  var vdt;
  var rmks;
  var custName;
  var custCode;
  double previousBal = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    srno = widget.srno;
    vdt = widget.vdt;
    rmks = widget.rmks;
    custName = widget.custName;
    custCode = widget.custCode;
    previousBal = widget.preBal;
    //getPreviousBal(srno);
  }

  // getPreviousBal(srno) async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         "${ApiService.baseUrl}DirectSaleInvoice/CustCLBal?srno=$srno"));
  //
  //     if (response.statusCode == 200) {
  //       debugPrint('Previous Balance :  ${response.body}');
  //       previousBal = double.parse(response.body);
  //       return response.body;
  //     } else {
  //       debugPrint('Error: ${response.statusCode}');
  //       debugPrint('Response: ${response.body}');
  //
  //       return null;
  //     }
  //   } catch (e) {
  //     throw Exception("An error occurred: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Invoice Preview'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<SalesListDtlModel>>(
          future: dataController.fetchSalesListDetails(srno),
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
              final ledger = snapshot.data;
              return _buildPdfPreview(context, snapshot.data, previousBal);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPdfPreview(
    BuildContext context,
    List<SalesListDtlModel>? data,
    previousBal,
  ) {
    return PdfPreview(
      padding: EdgeInsets.all(0.0),
      enableScrollToPage: true,
      build: (format) => _generatePdf(format, context, data, previousBal),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    BuildContext context,
    List<SalesListDtlModel>? ledger,
    previousBal,
  ) async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/images/app_logo.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    var sumQty = 0.0;
    var sumGross = 0.0;
    var sumAmnt = 0.0;
    var gTotal = 0.0;

    NumberFormat formatter = NumberFormat("#,##0.00", "en_US");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE MMM d y hh:mm a').format(now);

    for (int i = 0; i < ledger!.length; i++) {
      sumQty += ledger[i].qTY!;
      sumGross += ledger[i].gRAMT!;
      sumAmnt += ledger[i].nETAMT!;
    }
    gTotal = previousBal + sumAmnt;

    String formattedSumQty = formatter.format(sumQty);
    String formattedSumGross = formatter.format(sumGross);
    String formattedSumAmnt = formatter.format(sumAmnt);
    String formattedPreviousBal = formatter.format(previousBal);
    String formattedGTotal = formatter.format(gTotal);
    debugPrint("Format Balance:  $formattedPreviousBal");
    debugPrint("P Balance:  $previousBal");

    pdf.addPage(pw.MultiPage(
        maxPages: 200,
        pageTheme: pw.PageTheme(),
        header: (pw.Context context) => pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.topLeft,
                          height: 50,
                          child: image1,
                        ),
                        pw.Text("$formattedDate"),
                      ]),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text("KHALID MEHMOOD FOAM CENTRE",
                        style: pw.TextStyle(
                            fontSize: 22,
                            decoration: pw.TextDecoration.underline,
                            fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic)),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text("3 Chamberlain Road Lahore",
                        style: pw.TextStyle(
                            fontSize: 14,
                            decoration: pw.TextDecoration.underline,
                            fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic)),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                        "Foam, Rexine, Adhesive(s) and Insulation Merchants",
                        style: pw.TextStyle(
                            fontSize: 14,
                            decoration: pw.TextDecoration.underline,
                            fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic)),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text("CUSTOMER INVOICE",
                        style: pw.TextStyle(
                          fontSize: 22,
                          color: PdfColors.grey,
                          fontWeight: pw.FontWeight.bold,
                        )),
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Customer',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            '$custName',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Invoice No',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            '$srno',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Address',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            '  ',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Invoice Date',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            '$vdt',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Phone No',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            '  ',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Align(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Customer ID',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            '$custCode',
                            style: pw.TextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'Item Name',
                                style: pw.TextStyle(),
                              ),
                            )),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'UoM',
                                style: pw.TextStyle(),
                              ),
                            )),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'Qty',
                                style: pw.TextStyle(),
                              ),
                            )),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'Rate',
                                style: pw.TextStyle(),
                              ),
                            )),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'Gross',
                                style: pw.TextStyle(),
                              ),
                            )),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            decoration: pw.BoxDecoration(
                                color: PdfColors.yellow200,
                                border: pw.Border.all()),
                            child: pw.Center(
                              child: pw.Text(
                                'Amount',
                                style: pw.TextStyle(),
                              ),
                            )),
                      )
                    ],
                  ),
                ]),
        footer: (pw.Context context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          'Remarks:  ',
                          style: pw.TextStyle(),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 6,
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('$rmks',
                            style: pw.TextStyle(
                              decoration: pw.TextDecoration.underline,
                            )),
                      ),
                    ),
                  ]),
                  pw.SizedBox(height: 10),
                  pw.Text(
                      "Warranty:     _____________________________________"),
                ]),
        build: (pw.Context context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < ledger.length; i++) ...[
                    pw.Table(border: pw.TableBorder.all(), columnWidths: {
                      0: pw.FlexColumnWidth(4),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(2),
                      3: pw.FlexColumnWidth(2),
                      4: pw.FlexColumnWidth(2),
                      5: pw.FlexColumnWidth(2),
                      //6: pw.FlexColumnWidth(1),
                    }, children: [
                      pw.TableRow(children: [
                        pw.Text("${ledger[i].iTEMNAME}"),
                        pw.Text("${ledger[i].fKUOM}",
                            textAlign: pw.TextAlign.center),
                        pw.Text("${ledger[i].qTY}",
                            textAlign: pw.TextAlign.right),
                        pw.Text("${ledger[i].rATE}",
                            textAlign: pw.TextAlign.right),
                        pw.Text("${ledger[i].gRAMT}",
                            textAlign: pw.TextAlign.right),
                        pw.Text("${ledger[i].nETAMT}",
                            textAlign: pw.TextAlign.right),
                      ]),
                      if (i == ledger.length - 1) ...[
                        pw.TableRow(children: [
                          pw.Text("Total", textAlign: pw.TextAlign.center),
                          pw.Text(" "),
                          pw.Text("$formattedSumQty",
                              textAlign: pw.TextAlign.right),
                          pw.Text(" ", textAlign: pw.TextAlign.right),
                          pw.Text("$formattedSumGross",
                              textAlign: pw.TextAlign.right),
                          pw.Text("$formattedSumAmnt",
                              textAlign: pw.TextAlign.right),
                        ])
                      ]
                    ]),
                    if (i == ledger.length - 1) ...[
                      pw.SizedBox(height: 40),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 6,
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              'Previous Balance:  ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(5.0),
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text('$formattedPreviousBal',
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            )),
                      ]),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 6,
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              'Invoice Amount:  ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(5.0),
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text('$formattedSumAmnt',
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            )),
                      ]),
                      pw.Row(children: [
                        pw.Expanded(
                          flex: 6,
                          child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              'Grand Total:  ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              padding: pw.EdgeInsets.all(5.0),
                              decoration:
                                  pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Text('$formattedGTotal',
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            )),
                      ]),
                    ]
                  ],
                ],
              )
            ]));
    return pdf.save();
  }
}
