import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<List<Event>> fetchEvents(http.Client client, String accountId) async {
  if (accountId.isEmpty) {
    throw Exception('User not logged in');
  }
  debugPrint("fetching events");
  final response =
      await client.get(Uri.parse('$backendURL/$eventPath/$accountId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable list = json.decode(response.body);
    List<Event> events =
        List<Event>.from(list.map((model) => Event.fromJson(model)));
    return events;
  } else {
    debugPrint(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to obtain events');
  }
}

Future<Event> createEvents(
    Event event, File videoFile, List<File> images) async {
  var request = http.MultipartRequest(
      'post', Uri.parse('$backendURL/$eventPath/$createPath/'));

  debugPrint("creating events");

  for (var image in images) {
    request.files.add(await http.MultipartFile.fromPath("images", image.path,
        contentType: MediaType('multipart', 'form-data')));
  }

  request.files.add(await http.MultipartFile.fromPath("video", videoFile.path,
      contentType: MediaType('multipart', 'form-data')));

  request.files.add(http.MultipartFile.fromBytes(
      'event', utf8.encode(json.encode(event.toJson())),
      contentType: MediaType('application', 'json', {'charset': 'utf-8'})));

  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Event.fromJson(jsonDecode(response.body));
  } else {
    debugPrint(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to create events');
  }
}
