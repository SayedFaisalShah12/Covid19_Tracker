import 'package:coronatraker/Structure/StateServices.dart';
import 'package:coronatraker/View/DetailStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesState extends StatefulWidget {
  const CountriesState({super.key});

  @override
  State<CountriesState> createState() => _CountriesStateState();
}

class _CountriesStateState extends State<CountriesState> {
  TextEditingController SearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     StateServices stateservice = StateServices();

    return  Scaffold(
      appBar: AppBar(
        ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: SearchController,
                onChanged: (value){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Search Country By Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
              ),
            ),
            Expanded(
                child: FutureBuilder(
                  future: stateservice.CountriesListApi(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                    print(snapshot);
                  if(!snapshot.hasData){
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index){
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Column(
                            children: [
                              ListTile(
                                leading:  Container(height: 50 , width: 50, color: Colors.white,),
                                title:  Container(
                                  width: 100,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                subtitle:  Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    );

                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                        String name = snapshot.data![index]['country'];

                        if(SearchController.text.isEmpty)
                          {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(
                                        image: snapshot.data![index]['countryInfo']['flag'],
                                        name: snapshot.data![index]['country'],
                                        totalCases: snapshot.data![index]['cases'],
                                        totalDeaths: snapshot.data![index]['deaths'],
                                        totalRecovered: snapshot.data![index]['recovered'],
                                        active: snapshot.data![index]['active'],
                                        critical: snapshot.data![index]['critical'],
                                        todayRecovered: snapshot.data![index]['todayRecovered'],
                                        test: snapshot.data![index]['tests']
                                    )
                                    ));
                                  },
                               child: ListTile(
                                    title:Text(snapshot.data![index]['country']),
                                    subtitle: Text("Total Cases : ${snapshot.data![index]['cases']}"),
                                    leading: Image(
                                      height:50,
                                      width: 50,
                                      image: NetworkImage(
                                          snapshot.data![index]['countryInfo']['flag']),)
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          }

                        else if(name.toLowerCase().contains(SearchController.text.toLowerCase()))
                          {
                            return Column(
                              children: [
                                ListTile(
                                    title:Text(snapshot.data![index]['country']),
                                    subtitle: Text("Total Cases : ${snapshot.data![index]['cases']}".toString()),
                                    leading: Image(
                                      height:50,
                                      width: 50,
                                      image: NetworkImage(
                                          snapshot.data![index]['countryInfo']['flag']
                                      ),
                                    )
                                ),
                                Divider(),
                              ],
                            );
                          }

                        else
                          {
                           return Container();
                          }

                        }
                    );
                  }
              },
            )),
          ],
        ),
      ),
    );
  }
}
