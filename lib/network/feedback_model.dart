import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class FeedbackApi {
  final String id;
  final String subject;
  final String content;
  final String created;

  const FeedbackApi(
    this.id,
    this.subject,
    this.content,
    this.created,
  );

  factory FeedbackApi.fromJson(Map<String, dynamic> json) {
    return FeedbackApi(
        json['id'], json['subject'], json['content'], json['created_at']);
  }

  factory FeedbackApi.createFeedback(Map<String, dynamic> json) {
    return FeedbackApi(
        json['id'], json['subject'], json['content'], json['created_at']);
  }
}

Future findOne() async {
  try {
    final response = await http.get(Uri.parse(
        'https://quantums-service.quantums.web.id/api/v1/feedback/5cb82696-a1df-41fd-bc7b-7308089c2038'));
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var feedbackData = (jsonObject as Map<String, dynamic>)['content'];
      return FeedbackApi.fromJson(feedbackData);
    }
  } catch (e) {
    log(e.toString());
  }
}

Future findAll() async {
  String url = 'https://quantums-service.quantums.web.id/api/v1/feedback';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var allFeedback = (jsonObject as Map<String, dynamic>)['content'];
      return FeedbackApi.fromJson(allFeedback);
    }
  } catch (e) {
    log(e.toString());
  }
}

Future createFeedback(String subject, String content) async {
  String url = 'https://quantums-service.quantums.web.id/api/v1/feedback';
  try {
    final response = await http
        .post(Uri.parse(url), body: {"subject": subject, "content": content});
    var jsonObject = json.decode(response.body);

    return FeedbackApi.fromJson(jsonObject);
  } catch (e) {
    log(e.toString());
  }
}
