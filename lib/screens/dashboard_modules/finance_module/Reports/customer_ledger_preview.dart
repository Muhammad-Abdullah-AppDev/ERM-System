import 'package:flutter/services.dart';
import 'package:scarlet_erm/components/my_card.dart';
import 'package:scarlet_erm/components/priewcard.dart';
import 'package:scarlet_erm/models/customer_ledger_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../components/headingCard.dart';
import '../../../../services/api_service.dart';
import '../../../../theme/color_scheme.dart';

// ignore: must_be_immutable
class CustomeLedgerPreview extends StatefulWidget {
  CustomeLedgerPreview({super.key, this.fromDate, this.ToDate, this.psctd});
  final fromDate;
  final ToDate;
  final psctd;

  @override
  State<CustomeLedgerPreview> createState() => _CustomeLedgerPreviewState();
}

class _CustomeLedgerPreviewState extends State<CustomeLedgerPreview> {
  // final dateFormat = DateFormat("dd-MMM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black54,
      appBar: AppBar(
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Customer Ledger'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrintPreview(
                            psctd: widget.psctd,
                            fromDate: widget.fromDate,
                            ToDate: widget.ToDate,
                          )));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<CustomerLegderModel>>(
          future: ApiService.getCustomerLedger(
              "Ledger/GetLedger?pstcd=${widget.psctd}&stdt=${widget.fromDate}&endt=${widget.ToDate}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              //debugPrint(snapshot.error);
              return Center(
                child: Text('Something went wrong please try lator'),
              );
            }
            if (snapshot.hasData) {
              // // String? formatBalance;
              final ledger = snapshot.data;
              ////////////////////////
              List<double> debitValues = [];
              List<double> creditValues = [];
              List<double> balanceValues = [];
              double debitValue = 0.0;
              double creditValue = 0.0;

              // for (var i = 0; i < ledger!.length; i++) {
              //   double balance;
              //   debitValue = debitValue + ((ledger[i].debit ?? 0));
              //   creditValue = creditValue + ((ledger[i].credit ?? 0));
              //   // double debit = double.parse(debitValue);
              //   // double credit = double.parse(creditValue);
              //
              //   double opnBalance = ledger[i].opBal!.toDouble();
              //   balance = opnBalance == null ? 0.0 : opnBalance;
              //
              //   balance += (debitValue - creditValue);
              //
              //   debitValues.add(debitValue);
              //   creditValues.add(creditValue);
              //   balanceValues.add(balance);
              // }
              for (var item in ledger!) {
                debitValue += (item.debit ?? 0);
                creditValue += (item.credit ?? 0);
                double opnBalance = item.opBal ?? 0.0;
                double balance = opnBalance + (debitValue - creditValue);
                balanceValues.add(balance);
              }
              /////////////////////////
              var formatTempBal;
              var tempBal = 0.0;
              var tempDebit = 0.0;
              var tempCredit = 0.0;

              // tempBal = balanceValues[ledger.length - 1];
              // formatTempBal =
              //     NumberFormat("#,##0.##", "en_US").format(tempBal);
              // debugPrint('Last Balance: : $formatTempBal');
              //
              // tempDebit = ledger.fold(0, (prev, item) => prev + (item.debit ?? 0));
              // tempCredit = ledger.fold(0, (prev, item) => prev + (item.credit ?? 0));
              //tempBal = (ledger.first.opBal ?? 0) + (tempDebit - tempCredit);

              for (var i = 0; i < ledger.length; i++) {
                tempDebit = tempDebit + ((ledger[i].debit ?? 0));
                tempCredit = tempCredit + ((ledger[i].credit ?? 0));
              }
              var tempopbala = (ledger[0].opBal ?? 0);
              tempBal = tempopbala;
              tempBal = tempBal + (tempDebit - tempCredit);
              formatTempBal = NumberFormat("#,##0.##", "en_US").format(tempBal);
              debitValues.add(tempDebit);
              creditValues.add(tempCredit);
              balanceValues.add(tempBal);
              // print(ledger);
              ////// sum of debit and credit value
              double sumDebit = 0.0;
              double sumCredit = 0.0;
              for (int i = 0; i < ledger.length; i++) {
                sumDebit += (ledger[i].debit ?? 0);
                sumCredit += (ledger[i].credit ?? 0);
              }
              String formatDebit =
                  NumberFormat("#,##0.##", "en_US").format(sumDebit);
              String formatCredit =
                  NumberFormat("#,##0.##", "en_US").format(sumCredit);
              String formatOpeningBal = NumberFormat("#,##0.##", "en_US")
                  .format(ledger[0].opBal ?? 0);

              double openingBalance = ledger[0].opBal ?? 0;

              double balancevalue = openingBalance;
              DateTime _parseDate(String? dateStr) {
                if (dateStr != null) {
                  final dateParts = dateStr.split("-");
                  final day = int.parse(dateParts[0]);
                  final monthAbbreviation = dateParts[1];
                  final year = int.parse(dateParts[2]);

                  final Map<String, int> monthMap = {
                    'JAN': 1,
                    'FEB': 2,
                    'MAR': 3,
                    'APR': 4,
                    'MAY': 5,
                    'JUN': 6,
                    'JUL': 7,
                    'AUG': 8,
                    'SEP': 9,
                    'OCT': 10,
                    'NOV': 11,
                    'DEC': 12,
                  };

                  final month = monthMap[monthAbbreviation];

                  return DateTime(year, month!, day);
                }

                // Return a default value if the date string is null
                return DateTime.now();
              }

              // Sort the ledger list
              ledger.sort((a, b) {
                DateTime dateA = _parseDate(a.vdt);
                DateTime dateB = _parseDate(b.vdt);
                return dateA.compareTo(dateB);
              });

              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        '${ledger[0].name}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "From Date:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: fontGrey)),
                          TextSpan(
                              text: "${widget.fromDate}",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "To Date:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: fontGrey)),
                          TextSpan(
                              text: "${widget.ToDate}",
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        ])),
                      ],
                    ),

                    SizedBox(height: 10),
                    HeadingCard(
                      balance: 'Balance',
                      color: Theme.of(context).colorScheme.primary,
                      context: context,
                      credit: 'Credit',
                      debit: 'Debit',
                      name: 'Description',
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Openning Balance: ${formatOpeningBal.toString()}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),

                    SizedBox(height: 10),

                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              // color: Colors.amber,
                              child: ListView.builder(
                                itemCount: ledger.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var sortedLedger = ledger[index];
                                  debugPrint('ledger data: $sortedLedger');
                                  String? dateRange = sortedLedger.vdt;
                                  debugPrint('Date Range: $dateRange');
                                  String? formattedFromDate;

                                  if (dateRange != null) {
                                    final dateParts =
                                        dateRange.split(" ")[0].split("-");
                                    final day = int.parse(dateParts[0]);
                                    final monthAbbreviation = dateParts[1];
                                    final year = int.parse(dateParts[2]);

                                    final Map<String, int> monthMap = {
                                      'JAN': 1,
                                      'FEB': 2,
                                      'MAR': 3,
                                      'APR': 4,
                                      'MAY': 5,
                                      'JUN': 6,
                                      'JUL': 7,
                                      'AUG': 8,
                                      'SEP': 9,
                                      'OCT': 10,
                                      'NOV': 11,
                                      'DEC': 12,
                                    };

                                    final month = monthMap[monthAbbreviation];

                                    DateTime fromDateTime =
                                        DateTime(year, month!, day);
                                    formattedFromDate =
                                        "${fromDateTime.day}-${fromDateTime.month}-${fromDateTime.year}";
                                    debugPrint('date : $formattedFromDate');
                                  }

                                  // double debit = debitValues[index];
                                  // double credit = creditValues[index];
                                  double balance = balanceValues[index];

                                  NumberFormat formatter =
                                      NumberFormat("#,##0.##", "en_US");

                                  String formattedDebit =
                                      formatter.format(ledger[index].debit);
                                  debugPrint('debit : $formattedDebit');

                                  String formattedCredit =
                                      formatter.format(ledger[index].credit);
                                  debugPrint('credit : $formattedCredit');

                                  String formattedBalance =
                                      formatter.format(balance);

                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border.symmetric(
                                      horizontal: BorderSide(
                                          width: 1, color: Colors.grey),
                                    )),
                                    child: PreviewListCard(
                                      context: context,
                                      balance: formattedBalance,
                                      brand: "",
                                      credit: formattedCredit,
                                      date: '${formattedFromDate}',
                                      debit: formattedDebit,
                                      fair: "",
                                      unfair: ledger[index].unfair == null
                                          ? ""
                                          : "Un-Fare :   ${ledger.elementAt(index).unfair?.toInt()}",
                                      qty: "",
                                      rate: "",
                                      type: "${ledger.elementAt(index).srNo}",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Spacer(),
                    MyCard(
                      title: 'Closing Balance',
                      color: Theme.of(context).colorScheme.primary,
                      debit: '$formatDebit',
                      credit: '$formatCredit',
                      amount: "$formatTempBal",
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class PrintPreview extends StatefulWidget {
  const PrintPreview(
      {super.key,
      required this.fromDate,
      required this.ToDate,
      required this.psctd});
  final fromDate;
  final ToDate;
  final psctd;

  @override
  State<PrintPreview> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<PrintPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF144b9d),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Ledger Preview'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<CustomerLegderModel>>(
          future: ApiService.getCustomerLedger(
              "Ledger/GetLedger?pstcd=${widget.psctd}&stdt=${widget.fromDate}&endt=${widget.ToDate}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return Center(
                child: Text('Something went wrong please try lator'),
              );
            }
            if (snapshot.hasData) {
              // // String? formatBalance;
              final ledger = snapshot.data;
              ////////////////////////
              List<double> debitValues = [];
              List<double> creditValues = [];
              List<double> balanceValues = [];
              double debitValue = 0.0;
              double creditValue = 0.0;

              for (var item in ledger!) {
                debitValue += (item.debit ?? 0);
                creditValue += (item.credit ?? 0);
                double opnBalance = item.opBal ?? 0.0;
                double balance = opnBalance + (debitValue - creditValue);
                balanceValues.add(balance);
              }

              var formatTempBal;
              var tempBal = 0.0;
              var tempDebit = 0.0;
              var tempCredit = 0.0;

              for (var i = 0; i < ledger.length; i++) {
                tempDebit = tempDebit + ((ledger[i].debit ?? 0));
                tempCredit = tempCredit + ((ledger[i].credit ?? 0));
              }
              var tempopbala = (ledger[0].opBal ?? 0);
              tempBal = tempopbala;
              tempBal = tempBal + (tempDebit - tempCredit);
              formatTempBal = NumberFormat("#,##0.##", "en_US").format(tempBal);
              debitValues.add(tempDebit);
              creditValues.add(tempCredit);
              balanceValues.add(tempBal);
              // print(ledger);
              ////// sum of debit and credit value
              double sumDebit = 0.0;
              double sumCredit = 0.0;
              for (int i = 0; i < ledger.length; i++) {
                sumDebit += (ledger[i].debit ?? 0);
                sumCredit += (ledger[i].credit ?? 0);
              }
              String formatDebit =
                  NumberFormat("#,##0.##", "en_US").format(sumDebit);
              String formatCredit =
                  NumberFormat("#,##0.##", "en_US").format(sumCredit);
              String formatOpeningBal = NumberFormat("#,##0.##", "en_US")
                  .format(ledger[0].opBal ?? 0);

              double openingBalance = ledger[0].opBal ?? 0;

              double balancevalue = openingBalance;
              DateTime _parseDate(String? dateStr) {
                if (dateStr != null) {
                  final dateParts = dateStr.split("-");
                  final day = int.parse(dateParts[0]);
                  final monthAbbreviation = dateParts[1];
                  final year = int.parse(dateParts[2]);

                  final Map<String, int> monthMap = {
                    'JAN': 1,
                    'FEB': 2,
                    'MAR': 3,
                    'APR': 4,
                    'MAY': 5,
                    'JUN': 6,
                    'JUL': 7,
                    'AUG': 8,
                    'SEP': 9,
                    'OCT': 10,
                    'NOV': 11,
                    'DEC': 12,
                  };
                  final month = monthMap[monthAbbreviation];
                  return DateTime(year, month!, day);
                }
                return DateTime.now();
              }

              // Sort the ledger list
              ledger.sort((a, b) {
                DateTime dateA = _parseDate(a.vdt);
                DateTime dateB = _parseDate(b.vdt);
                return dateA.compareTo(dateB);
              });

              debugPrint("Balance Values://////    ${balanceValues}");

              return _buildPdfPreview(
                  context,
                  ledger,
                  snapshot.data,
                  formatDebit,
                  formatCredit,
                  formatOpeningBal,
                  formatTempBal,
                  balanceValues);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildPdfPreview(
      BuildContext context,
      List<CustomerLegderModel> ledger,
      List<CustomerLegderModel>? data,
      String formatDebit,
      String formatCredit,
      String formatOpeningBal,
      formatTempBal,
      List<double> balanceValues) {
    return PdfPreview(
      padding: EdgeInsets.all(0.0),
      enableScrollToPage: true,
      build: (format) => _generatePdf(format, context, ledger, formatDebit,
          formatCredit, formatOpeningBal, formatTempBal, balanceValues),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format,
      BuildContext context,
      List<CustomerLegderModel> ledger,
      String formatDebit,
      String formatCredit,
      String formatOpeningBal,
      formatTempBal,
      List<double> balanceValues) async {
    final pdf = pw.Document();

    NumberFormat formatter = NumberFormat("#,##0.00", "en_US");

    pdf.addPage(pw.MultiPage(
        maxPages: 200,
        pageTheme: pw.PageTheme(),
        header: (pw.Context context) => pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text("KHALID MEHMOOD FOAM CENTRE",
                        style: pw.TextStyle(
                            fontSize: 18,
                            decoration: pw.TextDecoration.underline,
                            fontWeight: pw.FontWeight.bold,
                            fontStyle: pw.FontStyle.italic)),
                  ),
                  pw.Text("Head Office",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text("Account Ledger Activity",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.SizedBox(height: 5),
                  pw.Row(children: [
                    pw.Text("From Date:   ${widget.fromDate}       "),
                    pw.Text("To Date:   ${widget.ToDate}"),
                  ]),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Date',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Number',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Description',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Debit',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Credit',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: pw.EdgeInsets.all(5.0),
                          color: PdfColors.yellow200,
                          child: pw.Align(
                            child: pw.Center(
                              child: pw.Text(
                                'Balance',
                                style: pw.TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  pw.Row(children: [
                    pw.Text(
                        "Acc Code & Name: ${ledger[0].fkMast}     ${ledger[0].name}   "),
                    pw.Text("      Opening: ${formatOpeningBal}"),
                  ]),
                  pw.Divider()
                ]),
        footer: (pw.Context context) => pw.Row(children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(5.0),
                  color: PdfColors.yellow200,
                  child: pw.Align(
                    child: pw.Center(
                      child: pw.Text(
                        'Account Total: ',
                        style: pw.TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(5.0),
                  color: PdfColors.yellow200,
                  child: pw.Align(
                    child: pw.Center(
                      child: pw.Text(
                        '${formatDebit}',
                        style: pw.TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(5.0),
                  color: PdfColors.yellow200,
                  child: pw.Align(
                    child: pw.Center(
                      child: pw.Text(
                        '${formatCredit}',
                        style: pw.TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(5.0),
                  color: PdfColors.yellow200,
                  child: pw.Align(
                    child: pw.Center(
                      child: pw.Text(
                        '$formatTempBal',
                        style: pw.TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        build: (pw.Context context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // pw.Text('Customer Ledger', style: pw.TextStyle(fontSize: 24)),
                  // pw.SizedBox(height: 10),
                  // pw.Row(
                  //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     pw.Text("From Date: ${widget.fromDate}"),
                  //     pw.Text("From Date: ${widget.ToDate}"),
                  //   ],
                  // ),
                  // pw.SizedBox(height: 10),

                  for (int i = 0; i < ledger.length; i++) ...[
                    pw.Table(columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(1.3),
                      2: pw.FlexColumnWidth(2),
                      3: pw.FlexColumnWidth(1),
                      4: pw.FlexColumnWidth(1),
                      5: pw.FlexColumnWidth(1.2),
                    }, children: [
                      pw.TableRow(children: [
                        pw.Text("${ledger[i].vdt}"),
                        pw.Text("${ledger[i].srNo!.substring(5)}", textAlign: pw.TextAlign.center),
                        pw.Text("${ledger[i].rmks}"),
                        pw.Text("${formatter.format(ledger[i].debit)} ",
                            textAlign: pw.TextAlign.right),
                        pw.Text("${formatter.format(ledger[i].credit)} ",
                            textAlign: pw.TextAlign.right),
                        pw.Text(" ${formatter.format(balanceValues[i])}",
                            textAlign: pw.TextAlign.right),
                      ]),
                    ]),
                  ],
                  // pw.SizedBox(height: 10),
                  // pw.Row(
                  //   mainAxisAlignment: pw.MainAxisAlignment.end,
                  //   children: [
                  //     pw.Align(
                  //       alignment: pw.Alignment.centerRight,
                  //       child: pw.Text(
                  //         'Openning Balance: ${NumberFormat("#,##0.##", "en_US").format(ledger[0].opBal ?? 0)}',
                  //         style: pw.TextStyle(
                  //           fontSize: 14,
                  //           //fontWeight: pw.FontWeight.w500
                  //         ),
                  //       ),
                  //     ),
                  //     pw.SizedBox(width: 10),
                  //   ],
                  // ),
                  // pw.SizedBox(height: 10),
                  // pw.Column(
                  //   children: [
                  //     pw.Container(
                  //       child: pw.ListView.builder(
                  //         itemCount: ledger.length,
                  //         itemBuilder: (pw.Context context, int index) {
                  //           var sortedLedger = ledger[index];
                  //           String? dateRange = sortedLedger.vdt;
                  //           String? formattedFromDate;
                  //
                  //           if (dateRange != null) {
                  //             final dateParts =
                  //             dateRange.split(" ")[0].split("-");
                  //             final day = int.parse(dateParts[0]);
                  //             final monthAbbreviation = dateParts[1];
                  //             final year = int.parse(dateParts[2]);
                  //
                  //             final Map<String, int> monthMap = {
                  //               'JAN': 1,
                  //               'FEB': 2,
                  //               'MAR': 3,
                  //               'APR': 4,
                  //               'MAY': 5,
                  //               'JUN': 6,
                  //               'JUL': 7,
                  //               'AUG': 8,
                  //               'SEP': 9,
                  //               'OCT': 10,
                  //               'NOV': 11,
                  //               'DEC': 12,
                  //             };
                  //
                  //             final month = monthMap[monthAbbreviation];
                  //
                  //             DateTime fromDateTime = DateTime(year, month!, day);
                  //             formattedFromDate =
                  //             "${fromDateTime.day}-${fromDateTime.month}-${fromDateTime.year}";
                  //             debugPrint('date : $formattedFromDate');
                  //           }
                  //           // double debit = debitValues[index];
                  //           // double credit = creditValues[index];
                  //           double balance = balanceValues[index];
                  //
                  //           NumberFormat formatter =
                  //           NumberFormat("#,##0.##", "en_US");
                  //
                  //           String formattedDebit =
                  //           formatter.format(ledger[index].debit);
                  //           debugPrint('debit : $formattedDebit');
                  //
                  //           String formattedCredit =
                  //           formatter.format(ledger[index].credit);
                  //           debugPrint('credit : $formattedCredit');
                  //
                  //           return pw.Container(
                  //             decoration: pw.BoxDecoration(
                  //                 border: pw.Border.symmetric(
                  //                     horizontal: pw.BorderSide(
                  //                         width: 1,
                  //                         color: PdfColor.fromInt(
                  //                             Colors.grey.value)))),
                  //
                  //             child: pw.Row(
                  //               children: [
                  //                 pw.Expanded(
                  //                   flex: 3,
                  //                   child: pw.SizedBox(
                  //                     height: 50,
                  //                     child: pw.Padding(
                  //                       padding: pw.EdgeInsets.all(4.0),
                  //                       child: pw.Column(
                  //                         mainAxisAlignment:
                  //                         pw.MainAxisAlignment.spaceBetween,
                  //                         crossAxisAlignment:
                  //                         pw.CrossAxisAlignment.start,
                  //                         children: [
                  //                           pw.Align(
                  //                             child: pw.Text(
                  //                               '${sortedLedger.srNo}',
                  //                               // style: TextStyle(
                  //                               //   fontSize: 12,
                  //                               //   fontWeight: FontWeight.w500,
                  //                               // ),
                  //                             ),
                  //                           ),
                  //                           pw.Align(
                  //                             alignment: pw.Alignment.center,
                  //                             child: pw.Text(
                  //                               '[$formattedFromDate]',
                  //                               style: pw.TextStyle(
                  //                                 fontSize: 12,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 pw.Expanded(
                  //                   flex: 2,
                  //                   child: pw.SizedBox(
                  //                     height: 50,
                  //                     child: pw.Padding(
                  //                       padding: pw.EdgeInsets.all(8.0),
                  //                       child: pw.Align(
                  //                         alignment: pw.Alignment.center,
                  //                         child: pw.Text(
                  //                           '${NumberFormat("#,##0.##", "en_US").format(sortedLedger.debit)}',
                  //                           style: pw.TextStyle(
                  //                             fontSize: 12,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 pw.Expanded(
                  //                   flex: 2,
                  //                   child: pw.SizedBox(
                  //                     height: 50,
                  //                     child: pw.Padding(
                  //                       padding: pw.EdgeInsets.all(8.0),
                  //                       child: pw.Align(
                  //                         alignment: pw.Alignment.center,
                  //                         child: pw.Text(
                  //                           '${NumberFormat("#,##0.##", "en_US").format(sortedLedger.credit)}',
                  //                           style: pw.TextStyle(
                  //                             fontSize: 12,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 pw.Expanded(
                  //                   flex: 2,
                  //                   child: pw.SizedBox(
                  //                     height: 50,
                  //                     child: pw.Padding(
                  //                       padding: pw.EdgeInsets.all(8.0),
                  //                       child: pw.Align(
                  //                         alignment: pw.Alignment.centerRight,
                  //                         child: pw.Text(
                  //                           '${NumberFormat("#,##0.##", "en_US").format(balance)}',
                  //                           style: pw.TextStyle(
                  //                             fontSize: 12,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // // MyCard(
                  // //   title: 'Closing Balance',
                  // //   color: Theme.of(context).colorScheme.primary,
                  // //   debit: '$formatDebit',
                  // //   credit: '$formatCredit',
                  // //   amount: "$formatTempBal",
                  // // )
                  // pw.Row(
                  //   children: [
                  //     pw.Expanded(
                  //       flex: 3,
                  //       child: pw.SizedBox(
                  //         height: 45,
                  //         child: pw.Padding(
                  //           padding: pw.EdgeInsets.all(4.0),
                  //           child: pw.Align(
                  //             alignment: pw.Alignment.center,
                  //             child: pw.Text('Closing Balance',
                  //                 style: pw.TextStyle(
                  //                   fontSize: 14,
                  //                   // color: pw.Colors.white,
                  //                   // fontWeight: FontWeight.w600,
                  //                 )),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     pw.Expanded(
                  //       flex: 2,
                  //       child: pw.SizedBox(
                  //         height: 45,
                  //         child: pw.Padding(
                  //           padding: pw.EdgeInsets.all(4.0),
                  //           child: pw.Align(
                  //             alignment: pw.Alignment.center,
                  //             child: pw.Text('$formatDebit',
                  //                 style: pw.TextStyle(
                  //                   fontSize: 14,
                  //                   // color: Colors.white,
                  //                   // fontWeight: FontWeight.w600,
                  //                 )),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     pw.Expanded(
                  //       flex: 2,
                  //       child: pw.SizedBox(
                  //         height: 45,
                  //         child: pw.Padding(
                  //           padding: pw.EdgeInsets.all(4.0),
                  //           child: pw.Align(
                  //             alignment: pw.Alignment.center,
                  //             child: pw.Text('$formatCredit',
                  //                 style: pw.TextStyle(
                  //                   fontSize: 14,
                  //                   // color: Colors.white,
                  //                   // fontWeight: FontWeight.w600,
                  //                 )),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     // SizedBox(width: 20)
                  //     pw.Expanded(
                  //       flex: 2,
                  //       child: pw.SizedBox(
                  //         height: 45,
                  //         child: pw.Padding(
                  //           padding: pw.EdgeInsets.all(4.0),
                  //           child: pw.Align(
                  //             alignment: pw.Alignment.center,
                  //             child: pw.Text('$formatTempBal',
                  //                 style: pw.TextStyle(
                  //                   fontSize: 14,
                  //                   // color: Colors.white,
                  //                   // fontWeight: FontWeight.w600,
                  //                 )),
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              )
            ]

        // return pw.Column(
        //   crossAxisAlignment: pw.CrossAxisAlignment.start,
        //   children: [
        //     pw.Text('Customer Ledger', style: pw.TextStyle(fontSize: 24)),
        //     pw.SizedBox(height: 10),
        //     pw.Row(
        //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        //       children: [
        //         pw.Text("From Date: ${widget.fromDate}"),
        //         pw.Text("From Date: ${widget.ToDate}"),
        //       ],
        //     ),
        //     pw.SizedBox(height: 10),
        //     // HeadingCard(
        //     // balance: 'Balance',
        //     // color: PdfColor.fromInt(Theme.of(context).colorScheme.primary.value),
        //     // context: context,
        //     // credit: 'Credit',
        //     // debit: 'Debit',
        //     // name: 'Description',
        //     // ),
        //     pw.Row(
        //       children: [
        //         pw.Expanded(
        //           flex: 3,
        //           child: pw.SizedBox(
        //             height: 50,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(5.0),
        //               child: pw.Align(
        //                 child: pw.Center(
        //                   child: pw.Text(
        //                     'Description',
        //                     style: pw.TextStyle(
        //                       //fontWeight: FontWeight.w600,
        //                       // color: Theme.of(context).brightness == Brightness.light
        //                       //     ? Theme.of(context).colorScheme.onPrimary
        //                       //     : Colors.white,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 50,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(5.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text(
        //                   'Debit',
        //                   // style: TextStyle(
        //                   //   fontWeight: FontWeight.w600,
        //                   //   color: Theme.of(context).brightness == Brightness.light
        //                   //       ? Theme.of(context).colorScheme.onPrimary
        //                   //       : Colors.white,
        //                   // ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 50,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(5.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text(
        //                   'Credit',
        //                   // style: TextStyle(
        //                   //   fontWeight: FontWeight.w600,
        //                   //   color: Theme.of(context).brightness == Brightness.light
        //                   //       ? Theme.of(context).colorScheme.onPrimary
        //                   //       : Colors.white,
        //                   // ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 50,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(5.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text(
        //                   'Balance',
        //                   // style: TextStyle(
        //                   //   fontWeight: FontWeight.w600,
        //                   //   color: Theme.of(context).brightness == Brightness.light
        //                   //       ? Theme.of(context).colorScheme.onPrimary
        //                   //       : Colors.white,
        //                   // ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     pw.SizedBox(height: 10),
        //     pw.Row(
        //       mainAxisAlignment: pw.MainAxisAlignment.end,
        //       children: [
        //         pw.Align(
        //           alignment: pw.Alignment.centerRight,
        //           child: pw.Text(
        //             'Openning Balance: ${NumberFormat("#,##0.##", "en_US").format(ledger[0].opBal ?? 0)}',
        //             style: pw.TextStyle(
        //               fontSize: 14,
        //               //fontWeight: pw.FontWeight.w500
        //             ),
        //           ),
        //         ),
        //         pw.SizedBox(width: 10),
        //       ],
        //     ),
        //     pw.SizedBox(height: 10),
        //     pw.Expanded(
        //       child: pw.Column(
        //         children: [
        //           pw.Expanded(
        //             child: pw.Container(
        //               child: pw.ListView.builder(
        //                 itemCount: ledger.length,
        //                 itemBuilder: (pw.Context context, int index) {
        //                   var sortedLedger = ledger[index];
        //                   String? dateRange = sortedLedger.vdt;
        //                   String? formattedFromDate;
        //
        //                   if (dateRange != null) {
        //                     final dateParts =
        //                     dateRange.split(" ")[0].split("-");
        //                     final day = int.parse(dateParts[0]);
        //                     final monthAbbreviation = dateParts[1];
        //                     final year = int.parse(dateParts[2]);
        //
        //                     final Map<String, int> monthMap = {
        //                       'JAN': 1,
        //                       'FEB': 2,
        //                       'MAR': 3,
        //                       'APR': 4,
        //                       'MAY': 5,
        //                       'JUN': 6,
        //                       'JUL': 7,
        //                       'AUG': 8,
        //                       'SEP': 9,
        //                       'OCT': 10,
        //                       'NOV': 11,
        //                       'DEC': 12,
        //                     };
        //
        //                     final month = monthMap[monthAbbreviation];
        //
        //                     DateTime fromDateTime = DateTime(year, month!, day);
        //                     formattedFromDate =
        //                     "${fromDateTime.day}-${fromDateTime.month}-${fromDateTime.year}";
        //                     debugPrint('date : $formattedFromDate');
        //                   }
        //                   // double debit = debitValues[index];
        //                   // double credit = creditValues[index];
        //                   double balance = balanceValues[index];
        //
        //                   NumberFormat formatter =
        //                   NumberFormat("#,##0.##", "en_US");
        //
        //                   String formattedDebit =
        //                   formatter.format(ledger[index].debit);
        //                   debugPrint('debit : $formattedDebit');
        //
        //                   String formattedCredit =
        //                   formatter.format(ledger[index].credit);
        //                   debugPrint('credit : $formattedCredit');
        //
        //                   String formattedBalance = formatter.format(balance);
        //
        //                   return pw.Container(
        //                     decoration: pw.BoxDecoration(
        //                         border: pw.Border.symmetric(
        //                             horizontal: pw.BorderSide(
        //                                 width: 1,
        //                                 color: PdfColor.fromInt(
        //                                     Colors.grey.value)))),
        //                     // child: PreviewListCard(
        //                     // context: context,
        //                     // balance: NumberFormat("#,##0.##", "en_US").format(balance),
        //                     // brand: "",
        //                     // credit: NumberFormat("#,##0.##", "en_US").format(sortedLedger.credit),
        //                     // date: '$formattedFromDate',
        //                     // debit: NumberFormat("#,##0.##", "en_US").format(sortedLedger.debit),
        //                     // fair: "",
        //                     // unfair: sortedLedger.unfair == null ? "" : "Un-Fare :   ${sortedLedger.unfair?.toInt()}",
        //                     // qty: "",
        //                     // rate: "",
        //                     // type: "${sortedLedger.srNo}",
        //                     // ),
        //                     child: pw.Row(
        //                       children: [
        //                         pw.Expanded(
        //                           flex: 3,
        //                           child: pw.SizedBox(
        //                             height: 50,
        //                             child: pw.Padding(
        //                               padding: pw.EdgeInsets.all(4.0),
        //                               child: pw.Column(
        //                                 mainAxisAlignment:
        //                                 pw.MainAxisAlignment.spaceBetween,
        //                                 crossAxisAlignment:
        //                                 pw.CrossAxisAlignment.start,
        //                                 children: [
        //                                   pw.Align(
        //                                     child: pw.Text(
        //                                       '${sortedLedger.srNo}',
        //                                       // style: TextStyle(
        //                                       //   fontSize: 12,
        //                                       //   fontWeight: FontWeight.w500,
        //                                       // ),
        //                                     ),
        //                                   ),
        //                                   pw.Align(
        //                                     alignment: pw.Alignment.center,
        //                                     child: pw.Text(
        //                                       '[$formattedFromDate]',
        //                                       style: pw.TextStyle(
        //                                         fontSize: 12,
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         pw.Expanded(
        //                           flex: 2,
        //                           child: pw.SizedBox(
        //                             height: 50,
        //                             child: pw.Padding(
        //                               padding: pw.EdgeInsets.all(8.0),
        //                               child: pw.Align(
        //                                 alignment: pw.Alignment.center,
        //                                 child: pw.Text(
        //                                   '${NumberFormat("#,##0.##", "en_US").format(sortedLedger.debit)}',
        //                                   style: pw.TextStyle(
        //                                     fontSize: 12,
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         pw.Expanded(
        //                           flex: 2,
        //                           child: pw.SizedBox(
        //                             height: 50,
        //                             child: pw.Padding(
        //                               padding: pw.EdgeInsets.all(8.0),
        //                               child: pw.Align(
        //                                 alignment: pw.Alignment.center,
        //                                 child: pw.Text(
        //                                   '${NumberFormat("#,##0.##", "en_US").format(sortedLedger.credit)}',
        //                                   style: pw.TextStyle(
        //                                     fontSize: 12,
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         pw.Expanded(
        //                           flex: 2,
        //                           child: pw.SizedBox(
        //                             height: 50,
        //                             child: pw.Padding(
        //                               padding: pw.EdgeInsets.all(8.0),
        //                               child: pw.Align(
        //                                 alignment: pw.Alignment.centerRight,
        //                                 child: pw.Text(
        //                                   '${NumberFormat("#,##0.##", "en_US").format(balance)}',
        //                                   style: pw.TextStyle(
        //                                     fontSize: 12,
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     // MyCard(
        //     //   title: 'Closing Balance',
        //     //   color: Theme.of(context).colorScheme.primary,
        //     //   debit: '$formatDebit',
        //     //   credit: '$formatCredit',
        //     //   amount: "$formatTempBal",
        //     // )
        //     pw.Row(
        //       children: [
        //         pw.Expanded(
        //           flex: 3,
        //           child: pw.SizedBox(
        //             height: 45,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(4.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text('Closing Balance',
        //                     style: pw.TextStyle(
        //                       fontSize: 14,
        //                       // color: pw.Colors.white,
        //                       // fontWeight: FontWeight.w600,
        //                     )),
        //               ),
        //             ),
        //           ),
        //         ),
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 45,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(4.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text('$formatDebit',
        //                     style: pw.TextStyle(
        //                       fontSize: 14,
        //                       // color: Colors.white,
        //                       // fontWeight: FontWeight.w600,
        //                     )),
        //               ),
        //             ),
        //           ),
        //         ),
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 45,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(4.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text('$formatCredit',
        //                     style: pw.TextStyle(
        //                       fontSize: 14,
        //                       // color: Colors.white,
        //                       // fontWeight: FontWeight.w600,
        //                     )),
        //               ),
        //             ),
        //           ),
        //         ),
        //         // SizedBox(width: 20)
        //         pw.Expanded(
        //           flex: 2,
        //           child: pw.SizedBox(
        //             height: 45,
        //             child: pw.Padding(
        //               padding: pw.EdgeInsets.all(4.0),
        //               child: pw.Align(
        //                 alignment: pw.Alignment.center,
        //                 child: pw.Text('$formatTempBal',
        //                     style: pw.TextStyle(
        //                       fontSize: 14,
        //                       // color: Colors.white,
        //                       // fontWeight: FontWeight.w600,
        //                     )),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ],
        // );
        //}
        ));
    return pdf.save();
  }
}
