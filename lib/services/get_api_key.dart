import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class ApiKey 
{

  late String apiKey;
  String baseURL="http://aniansh-planets-api.herokuapp.com/api_key";
  final String passPhrase='papajones-mamamia';
  Future<String> getJsonFromStore()async
  {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final jsonString = prefs.getString('api_key') ?? "";
    
    return jsonString;
    

  }

  void saveJsonToStore(String jsonString)async
  {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('api_key', jsonString);
  }




  Future<String> fetchData()async
  {
    Response response;
    String jsonString="";

    

    try //* try fetching data from api
    {
      // print('${this.baseURL}?key=${this.passPhrase}');
      response = await get('${this.baseURL}?key=${this.passPhrase}');
      jsonString = response.body;
      saveJsonToStore(jsonString);
    } catch (e) //*if cant fetch, try reading from store
    {
      jsonString = await getJsonFromStore();
    }
    
  
   
    return jsonString;
  }



  Future<bool> getData()async
  {
    //*init
    // List data = List();
    // this.formattedData = List();
    String jsonString;

    jsonString = await fetchData();

    if(jsonString=="")
    {
      return false;
    }
   
    this.apiKey=jsonString;
    return true;
  

  }
 
  
}
