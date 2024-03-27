import 'package:coronatraker/Models/WorldStateModel.dart';
import 'package:coronatraker/Structure/StateServices.dart';
import 'package:coronatraker/View/CountriesState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WorldStatus extends StatefulWidget {
  const WorldStatus({super.key});

  @override
  State<WorldStatus> createState() => _WorldStatusState();
}

class _WorldStatusState extends State<WorldStatus> with TickerProviderStateMixin {

  late final AnimationController  controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
  )..repeat();

  void dispose(){
    super.dispose();
    controller.dispose();
  }
  final colorlistPick =<Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StateServices statservice = StateServices();
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                     FutureBuilder(
                         future: statservice.fetchWorkStateRecords(),
                         builder: (context,AsyncSnapshot<WorldStateModel> snapshot){
                            if(!snapshot.hasData)
                               {
                                return Expanded(
                                  flex: 1,
                                    child: SpinKitFadingCircle(
                                     color: Colors.white,
                                      controller: controller,
                                    )
                                );
                              }
                            else
                              {
                                return Column(
                                  children: [
                                    PieChart(
                                      legendOptions: const LegendOptions(
                                        legendPosition: LegendPosition.left,
                                      ),
                                      dataMap: {
                                        "Total":double.parse(snapshot.data!.cases!.toString()),
                                        "Recovered":double.parse(snapshot.data!.recovered!.toString()),
                                        "Death":double.parse(snapshot.data!.deaths!.toString()),
                                      },
                                      animationDuration: Duration(milliseconds: 1200),
                                      chartType: ChartType.disc,
                                      colorList: colorlistPick,
                                      chartValuesOptions: const ChartValuesOptions(
                                        showChartValuesInPercentage: true,
                                      ),
                                    ),
                                    Card(
                                      child: Column(
                                        children: [
                                          ReusableRow(title: "Total", value: snapshot.data!.cases.toString(),),
                                          ReusableRow(title: "Deaths", value: snapshot.data!.deaths.toString(),),
                                          ReusableRow(title: "Recovered", value: snapshot.data!.recovered.toString(),),
                                          ReusableRow(title: "Active", value: snapshot.data!.active.toString(),),
                                          ReusableRow(title: "Critical", value: snapshot.data!.critical.toString(),),
                                          ReusableRow(title: "Today Death", value: snapshot.data!.todayDeaths.toString(),),
                                          ReusableRow(title: "Today Recovered", value: snapshot.data!.todayRecovered.toString(),),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15,),

                                  ],
                                );
                              }
                         }),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => CountriesState()));
                      },
                      child: const Text("Track Country")
                  ),
                ],
            ),
          ),
          ),
    ]
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
   ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Text(title),
                  Text(value),
            ],
          ),
          const SizedBox(height: 10,),
          const Divider(),
        ],
      ),
    );
  }
}
