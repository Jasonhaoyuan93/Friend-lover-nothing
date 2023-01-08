import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<List<Application>> fetchApplications(
    http.Client client, String accountId) async {
  if (accountId.isEmpty) {
    throw Exception('User not logged in');
  }

  final response = await client
      .get(Uri.parse('$backendURL/$applicationPath/$ownerPath/$accountId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable list = json.decode(response.body);
    List<Application> applications = List<Application>.from(
        list.map((model) => Application.fromJson(model)));
    return applications;
  } else {
    debugPrint(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to obtain applicaitons');
  }
}

Future<void> closeApplications(
    http.Client client, Application application) async {
  final response = await client.post(
      Uri.parse('$backendURL/$applicationPath/$closeApplicationPath/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(application.toJson()));
  if (response.statusCode == 200) {
    debugPrint("successfully close application");
  }else{
    debugPrint(response.body);
  }
}

Future<Application> createApplication(Application account, File videoFile) async {
  var request = http.MultipartRequest(
      'post', Uri.parse('$backendURL/$applicationPath/$createPath/'));

   request.files.add(await http.MultipartFile.fromPath("video", videoFile.path,
      contentType: MediaType('multipart', 'form-data')));

  request.files.add(http.MultipartFile.fromBytes(
      'application', utf8.encode(json.encode(account.toJson())),
      contentType: MediaType('application', 'json', {'charset': 'utf-8'})));

  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Application.fromJson(jsonDecode(response.body));
  } else {
    debugPrint(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to updateAccount');
  }
}
