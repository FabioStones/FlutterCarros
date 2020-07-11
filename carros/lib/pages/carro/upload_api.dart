import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carros/pages/api_response.dart';
import 'package:http/src/response.dart';
import 'package:path/path.dart' as path;
import 'package:carros/utils/http_helper.dart' as http;

class UploadApi {
  static Future<ApiResponse<String>> upload(File file) async {
    try {
      var url = 'https://carros-springboot.herokuapp.com/api/v2/upload';

      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      String fileName = path.basename(file.path);

      var params = {
        "fileName": fileName,
        "mimeType": "image/jpeg",
        "base64": base64Image
      };

      String json = jsonEncode(params);

      print("htto.upload:" + url);
      print("params:" + json);

      final response = await http.post(url,
          body: json).timeout(Duration(seconds: 120), onTimeout: _onTimeOut);
          print("http.upload << " + response.body);

      Map<String, dynamic> map = jsonDecode(response.body);

      return ApiResponse.ok(map["url"]);
    } catch (error, exception) {
      print("Erro ao fazer upload $error - $exception");
      return ApiResponse.error("Não foi possível fazer o upload");
    }
  }

  static FutureOr<Response> _onTimeOut() {
    print("timeout");
    throw SocketException("Não foi possível se comunicar com o servidor");
  }
}