import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressChart extends StatefulWidget {
  const ProgressChart({
    Key? key,
    required this.chartTitle,
    required this.series,
    this.enableTooltip = false,
    this.backgroundColor,
  }) : super(key: key);
  final ChartTitle chartTitle;
  final dynamic series;
  final bool? enableTooltip;
  final Color? backgroundColor;

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: widget.enableTooltip,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          // borderWidth: 5.0,

          primaryXAxis: CategoryAxis(),
          backgroundColor: widget.backgroundColor,
          // Chart title
          title: widget.chartTitle,
          // Enable legend
          // legend: Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: _tooltipBehavior,
          series: widget.series,
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final num sales;
}
