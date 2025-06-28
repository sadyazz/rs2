import 'dart:convert';
import 'package:ecinema_desktop/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class MovieProvider{
  MovieProvider(){

  } 

  Future<dynamic> get() async{
    var url = 'http://localhost:5190/Movie';
    var uri = Uri.parse(url);
    var response = await http.get(uri, headers: createHeaders());

    if(isValidResonse(response)){
      var data = jsonDecode(response.body);
      return data;
    }else{
      throw new Exception('Unknown exception');
    }
  }

  bool isValidResonse(Response response){
    if(response.statusCode < 299){
      return true;
    }else if(response.statusCode == 401){
      throw new Exception('Unauthorized');
    }else{
      throw new Exception('Something went wrong, please try again later');
    }
  }

  Map<String, String> createHeaders(){
    String username = AuthProvider.username!;
    String password = AuthProvider.password!;

    String basicAuth = "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      'Content-Type': 'application/json',
      'Authorization': basicAuth,
    };
  }
}