import 'dart:convert';
import 'main.dart';

class ApiFeedback {
  final ApiBase _api = ApiBase();

  Future<AppRespond> findAll() async {
    print("DI PANGGIL #####");
    final res = await _api.get('${_api.apiV1}/feedback', null);
    return AppRespond.fromJson(res);
  }

  Future<AppRespond> findOne(String id) async {
    final res = await _api.get("${_api.apiV1}/feedback/$id", null);
    return AppRespond.fromJson(res);
  }

  Future<AppRespond> create(Map body) async {
    final res = await _api.post("${_api.apiV1}/feedback", jsonEncode(body));
    return AppRespond.fromJson(res);
  }

  Future<AppRespond> update(String id, Map body) async {
    final res = await _api.put("${_api.apiV1}/feedback/$id", jsonEncode(body));
    return AppRespond.fromJson(res);
  }

  Future<AppRespond> delete(String id) async {
    final res = await _api.delete("${_api.apiV1}/feedback/$id");
    return AppRespond.fromJson(res);
  }
}
