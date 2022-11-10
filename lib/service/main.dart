import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// const storage = FlutterSecureStorage();
// const String encryptionKey = "mykeyEnc";
// const String apiHost = String.fromEnvironment("API_HOST", defaultValue: 'quantums-service.quantums.web.id');
const String apiHost = 'quantums-service.quantums.web.id';

class ApiBase {
  final apiV1 = 'api/v1';

  // Future readStorage(String key) async {
  //   return await storage.read(key: key);
  // }

  // Future writeToken(String token) async {
  //   return await storage.write(key: encryptionKey, value: token);
  // }

  // Future readToken() async {
  //   return await storage.read(key: encryptionKey);
  // }

  // Future readToken2() async {
  //   var token = await readToken();
  //   return token;
  // }

  // Future deleteToken() async {
  //   return await storage.delete(key: encryptionKey);
  // }

  Future<dynamic> get(String url, q) async {
    final query = q.toString().isNotEmpty ? q : null;
    // log('### API GET, URL : $url');
    // var token = await readToken();
    try {
      final res = await http.get(Uri.https(apiHost, url, query), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + token.toString()
      });
      // log("### " + res.toString());
      return _appResponse(res);
    } on SocketException {
      //
    }
  }

  Future<dynamic> post(String url, dynamic body) async {
    // log('### API POST, URL : $url');
    // var token = await readToken();
    try {
      final res =
          await http.post(Uri.https(apiHost, url), body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + token.toString()
      });
      return _appResponse(res);
    } on SocketException {
      //
    }
  }

  Future<dynamic> put(String url, dynamic body) async {
    // log('### API PUT, URL : $url');
    // var token = await readToken();
    try {
      final res = await http.put(Uri.https(apiHost, url), body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + token.toString()
      });
      return _appResponse(res);
    } on SocketException {
      //
    }
  }

  Future<dynamic> delete(String url) async {
    // log('### API DELETE, URL : $url');
    // var token = await readToken();
    try {
      final res = await http.delete(Uri.https(apiHost, url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer ' + token.toString()
      });
      return _appResponse(res);
    } on SocketException {
      //
    }
  }

  Future<dynamic> postFile(
      File file, Map<String, String> body, String url) async {
    // var token = await readToken();
    // final dataBody = {'letter_id': '2146822c-51a0-4f65-90fa-84feeb14c5aa'};
    final dataBody = body;
    try {
      var request = http.MultipartRequest('POST', Uri.https(apiHost, url))
        // ..headers['Authorization'] = 'Bearer ' + token.toString()
        ..fields.addAll(dataBody)
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final res = await request.send().then((value) => value);

      return _appStreamResponse(res);
    } on SocketException {
      //
    }
  }

  Future<dynamic> postBytes(
      List<int> bytes, Map<String, String> body, String url) async {
    // var token = await readToken();
    // final dataBody = {'letter_id': '2146822c-51a0-4f65-90fa-84feeb14c5aa'};
    final dataBody = body;
    print("SENDDDD 1");
    try {
      // final http.MultipartFile file = http.MultipartFile.fromBytes('file', bytes);
      // MapEntry<String, http.MultipartFile> imageEntry = MapEntry("image", file);
      var request = http.MultipartRequest('POST', Uri.https(apiHost, url))
        // ..headers['Authorization'] = 'Bearer ' + token.toString()
        ..fields.addAll(dataBody)
        ..files.add(http.MultipartFile.fromBytes('file', bytes));

      final res = await request.send().then((value) => value);
      print("SENDDDD 2");
      print(res.toString());

      return _appStreamResponse(res);
    } on SocketException {
      //
    }
  }
}

dynamic _appStreamResponse(http.StreamedResponse response) async {
  var resCode = response.statusCode;
  print("STREAM RESPONS");
  print(resCode);

  final resStream = await response.stream.bytesToString();
  if (resCode == 200 || resCode == 201 || resCode == 202) {
    var responseJson = json.decode(resStream);
    responseJson['type'] = 'success';
    responseJson['code'] = resCode;
    responseJson['message'] = responseJson['success'];
    return responseJson;
  } else if (resCode == 204) {
    var responseJson = json.decode('{}');
    responseJson['type'] = 'error';
    responseJson['code'] = resCode;
    responseJson['message'] = 'no content';
    return responseJson;
  } else if (resCode == 422) {
    var responseJson = json.decode(resStream);
    print(responseJson);
    String firstKey = responseJson['error'].keys.elementAt(0);
    responseJson['type'] = 'error';
    responseJson['code'] = resCode;
    responseJson['message'] = responseJson['error'][firstKey][0];
    return responseJson;
  } else if (resCode > 400) {
    // routemaster.push('/error/$resCode');
  } else {
    throw FetchDataException(
        'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

dynamic _appResponse(http.Response response) async {
  var resCode = response.statusCode;
  if (resCode == 200 || resCode == 201 || resCode == 202) {
    var responseJson = json.decode(response.body);
    responseJson['type'] = 'success';
    responseJson['code'] = resCode;
    responseJson['message'] = responseJson['success'];
    return responseJson;
  } else if (resCode == 204) {
    var responseJson = json.decode('{}');
    responseJson['type'] = 'error';
    responseJson['code'] = resCode;
    responseJson['message'] = 'no content';
    return responseJson;
  } else if (resCode == 422) {
    var responseJson = json.decode(response.body);
    String firstKey = responseJson['error'].keys.elementAt(0);
    responseJson['type'] = 'error';
    responseJson['code'] = resCode;
    responseJson['message'] = responseJson['error'][firstKey][0];
    return responseJson;
  } else if (resCode > 400) {
    // routemaster.push('/error/$resCode');
  } else {
    throw FetchDataException(
        'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

class AppRespond {
  int? code;
  String? type;
  String? message;
  Map<String, dynamic>? content;

  AppRespond({
    this.code,
    this.type,
    this.message,
    this.content,
  });

  factory AppRespond.fromJson(Map<String, dynamic> json) {
    return AppRespond(
        code: json['code'],
        type: json['type'],
        message: json['message'],
        content: json['content']);
  }
  Map<String, dynamic> toJson() {
    return {"code": code, "type": type, "message": message, "content": content};
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
