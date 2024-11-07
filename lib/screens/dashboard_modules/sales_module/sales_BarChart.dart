import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesBarChart extends StatefulWidget {

  // double custBal;
  // double bankBal;
  // double cashBal;
  // double partyBal;

  SalesBarChart({
    // required this.custBal,
    // required this.bankBal,
    // required this.cashBal,
    // required this.partyBal,
    super.key});

  @override
  State<SalesBarChart> createState() => _SalesBarChartState();
}

class _SalesBarChartState extends State<SalesBarChart> {

  final _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey.withOpacity(0.1),
      // appBar: AppBar(
      //   backgroundColor: Colors.lightBlue,
      //   title: const Text('Finance Report'),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 280,
                child: SfCartesianChart(
                  title: ChartTitle(
                    text: "Monthly Report"
                  ),
                  enableAxisAnimation: true,
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<SalesData, String>(
                      dataSource: <SalesData>[
                        SalesData('Jan', 100),
                        SalesData('Feb', 150),
                        SalesData('Mar', 200),
                        SalesData('Apr', 180),
                        SalesData('May', 220),
                        SalesData('Jun', 200),
                        SalesData('Jul', 150),
                        SalesData('Aug', 250),
                        SalesData('Sep', 100),
                        SalesData('Oct', 50),
                        SalesData('Nov', 250),
                        SalesData('Dec', 400),
                      ],
                      xValueMapper: (SalesData sales, _) => sales.month,
                      yValueMapper: (SalesData sales, _) => sales.amount,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              indent: 30,
              endIndent: 30,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 340,
                child: SfCircularChart(
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<SalesData, String>(
                      radius: "90%",
                      dataSource: <SalesData>[
                        SalesData('Jan', 100),
                        SalesData('Feb', 150),
                        SalesData('Mar', 200),
                        SalesData('Apr', 180),
                        SalesData('May', 220),
                        SalesData('Jun', 200),
                        SalesData('Jul', 150),
                        SalesData('Aug', 250),
                        SalesData('Sep', 100),
                        SalesData('Oct', 50),
                        SalesData('Nov', 250),
                        SalesData('Dec', 400),
                      ],
                      xValueMapper: (SalesData sales, _) => sales.month,
                      yValueMapper: (SalesData sales, _) => sales.amount,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //   child: Wrap(
            //     alignment: WrapAlignment.center,
            //     children: _getLegendItems(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // List<ChartData> _getChartData() {
  //   return <ChartData>[
  //     ChartData('Customer Balance', widget.custBal),
  //     ChartData('Bank Balance', widget.bankBal),
  //     ChartData('Cash Balance', widget.cashBal),
  //     ChartData('Party Balance', widget.partyBal),
  //   ];
  // }

  // List<Widget> _getLegendItems() {
  //   List<Widget> legendItems = [];
  //   int itemsPerRow = 2;
  //
  //   List<Widget> currentRowItems = [];
  //   for (ChartData data in _getChartData()) {
  //     currentRowItems.add(
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Container(
  //               width: 15,
  //               height: 15,
  //               color: _getColor(data.category),
  //             ),
  //             const SizedBox(width: 5),
  //             Text(data.category),
  //           ],
  //         ),
  //       ),
  //     );
  //
  //     if (currentRowItems.length == itemsPerRow) {
  //       legendItems.add(Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: currentRowItems,
  //       ));
  //       currentRowItems = [];
  //     }
  //   }
  //
  //   if (currentRowItems.isNotEmpty) {
  //     legendItems.add(Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: currentRowItems,
  //     ));
  //   }
  //
  //   return legendItems;
  // }

  // Color _getColor(String category) {
  //   // Define your color mapping logic here
  //   Map<String, Color> colorMap = {
  //     'Customer Balance': const Color(0xff4b87b9),
  //     'Bank Balance': const Color(0xffc06c84),
  //     'Cash Balance': const Color(0xfff67280),
  //     'Party Balance': const Color(0xfff6b095),
  //   };
  //   return colorMap[category] ?? Colors.grey;
  // }
}


class SalesData {
  final String month;
  final double amount;

  SalesData(this.month, this.amount);
}

