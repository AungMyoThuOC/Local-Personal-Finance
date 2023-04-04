// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:personal_finance/Pages/Home/income_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:personal_finance/Pages/outcome/outcome.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  int id;
  HomePage({Key? key, required this.id}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabController? controller;

  int key = 0;

  Map<String, double> dataMap = {"income": 7, "outcome": 3, "saving": 2};

  List<Color> colorList = [
    const Color(0xFFB0B7C0),
    Colors.grey,
    const Color(0xFF595E60),
    // const Color(0xffFA4A42),
    // const Color(0xff3398F6),
    // const Color(0xffFE9539),
    // const Color(0xffD95AF3),
    // const Color(0xff3EE094),
  ];

  Widget pieChart() {
    return PieChart(
      dataMap: dataMap,
      initialAngleInDegree: 0,
      animationDuration: const Duration(milliseconds: 900),
      chartType: ChartType.disc,
      chartRadius: MediaQuery.of(context).size.width / 2.5,
      ringStrokeWidth: 35,
      colorList: colorList,
      chartLegendSpacing: 35,
      chartValuesOptions: const ChartValuesOptions(
          showChartValuesOutside: false,
          showChartValuesInPercentage: false,
          showChartValueBackground: true,
          showChartValues: true,
          chartValueStyle: TextStyle(color: Colors.black)),
      // centerText: ,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendPosition: LegendPosition.right,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                              fontSize: 21,
                              color: Color(0xFF3b3b3b),
                              fontWeight: FontWeight.bold),
                        ),
                        const Gap(15),
                        const Text(
                          "Personal Finance",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3b3b3b),
                              fontWeight: FontWeight.w500),
                        ),
                        const Gap(25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                pieChart(),
                              ],
                            ),
                            const Gap(40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.grey[300])),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: IncomePage(
                                                  id: 2,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      },
                                      child: const Text(
                                        "INCOME",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.grey[300])),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: OutcomePage(
                                                  id: 2,
                                                ),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      },
                                      child: const Text(
                                        "OUTCOME",
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



// GestureDetector(
//                                   onTap: () {
//                                     print("tab");
//                                   },
//                                   child: Container(
                                    
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: [Colors.grey, Colors.grey],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       borderRadius: BorderRadius.circular(2),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.white70,
//                                           offset: Offset(5, 5),
//                                           blurRadius: 10,
//                                         )
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'Press',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 30,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
