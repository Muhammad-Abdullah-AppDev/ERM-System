import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FinancialPieChart extends StatefulWidget {

  double custBal;
  double bankBal;
  double cashBal;
  double partyBal;

  FinancialPieChart({
    required this.custBal,
    required this.bankBal,
    required this.cashBal,
    required this.partyBal,
    super.key});

  @override
  State<FinancialPieChart> createState() => _FinancialPieChartState();
}

class _FinancialPieChartState extends State<FinancialPieChart> {

  final _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.5),
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
                  height: 200,
                  child: SfCircularChart(
                   // palette: [Color.fromRGBO(r, g, b, opacity)],
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: _getChartData(),
                        xValueMapper: (ChartData data, _) => data.category,
                        yValueMapper: (ChartData data, _) => data.value,
                        startAngle: 90,
                        endAngle: 90,
                        innerRadius: '30%',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                alignment: WrapAlignment.center,
                children: _getLegendItems(),
              ),
              ),
            ],
          ),
        ),
    );
  }

  List<ChartData> _getChartData() {
    return <ChartData>[
      ChartData('Customer Balance', widget.custBal),
      ChartData('Bank Balance', widget.bankBal),
      ChartData('Cash Balance', widget.cashBal),
      ChartData('Party Balance', widget.partyBal),
    ];
  }

  List<Widget> _getLegendItems() {
    List<Widget> legendItems = [];
    int itemsPerRow = 2;

    List<Widget> currentRowItems = [];
    for (ChartData data in _getChartData()) {
      currentRowItems.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 15,
                height: 15,
                color: _getColor(data.category),
              ),
              const SizedBox(width: 5),
              Text(data.category),
            ],
          ),
        ),
      );

      if (currentRowItems.length == itemsPerRow) {
        legendItems.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: currentRowItems,
        ));
        currentRowItems = [];
      }
    }

    if (currentRowItems.isNotEmpty) {
      legendItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: currentRowItems,
      ));
    }

    return legendItems;
  }

  Color _getColor(String category) {
    // Define your color mapping logic here
    Map<String, Color> colorMap = {
      'Customer Balance': Colors.lightBlue,
      'Bank Balance': Colors.deepPurpleAccent,
      'Cash Balance': Colors.blueGrey.shade700,
      'Party Balance': Colors.orangeAccent,
    };
    return colorMap[category] ?? Colors.grey;
  }
}


class ChartData {
  ChartData(this.category, this.value);

  final String category;
  final double value;
}
