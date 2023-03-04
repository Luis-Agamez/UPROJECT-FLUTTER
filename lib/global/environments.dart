import 'dart:io';

class Enviroment {
  static String apiUrlBase = Platform.isAndroid
      //? 'http://192.168.1.15:3000/api'
      ? 'http://192.168.31.172:3000/api'
      : 'localhost:3000/api';
}
