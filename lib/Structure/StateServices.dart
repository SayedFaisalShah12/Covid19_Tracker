import 'dart:convert';
import 'package:coronatraker/Models/WorldStateModel.dart';
import 'package:coronatraker/Utils/Url.dart';
import 'package:http/http.dart' as http;

class StateServices{
  Future <WorldStateModel> fetchWorkStateRecords() async{
      final response = await http.get(Uri.parse(appURL.worldStatesApi));

      if(response.statusCode == 200)
        {
          var data = jsonDecode(response.body);
          return WorldStateModel.fromJson(data);
        }
      else
        {
          throw Exception('Error');
        }
  }

  Future <List<dynamic>> CountriesListApi() async{
    var data;
    final response = await http.get(Uri.parse(appURL.coutriesList));

    if(response.statusCode == 200)
    {
      var data = jsonDecode(response.body);
      return data;
    }
    else
    {
      throw Exception('Error');
    }
  }
}
