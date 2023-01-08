import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:http/http.dart' as http;

Future<Account> fetchAccount(http.Client client, String accountId) async {
  if (accountId.isEmpty) {
    throw Exception('User not logged in');
  }

  final response =
      await client.get(Uri.parse('$backendURL/$accountPath/$accountId'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Account.fromJson(jsonDecode(response.body));
  } else {
    debugPrint(response.body);
    // debugPrint(json.decode(response.body));
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to obtain Account');
  }
}

Future<Account> fetchPublicAccount(http.Client client, String accountId) {
  if (accountId.isEmpty) {
    throw Exception('User not logged in');
  }

  return client
      .get(Uri.parse('$backendURL/$accountPath/$accountId'))
      .then((response) {
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Account.fromJson(jsonDecode(response.body));
    } else {
      debugPrint(response.body);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to obtain Account');
    }
  });
}

Future<Account> updateAccount(Account account, File? image) async {
  var request = http.MultipartRequest(
      'post', Uri.parse('$backendURL/$accountPath/$updatePath/'));
  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath("file", image.path,
        contentType: MediaType('multipart', 'form-data')));
  }
  request.files.add(http.MultipartFile.fromBytes(
      'account', utf8.encode(json.encode(account.toJson())),
      contentType: MediaType('application', 'json', {'charset': 'utf-8'})));

  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Account.fromJson(jsonDecode(response.body));
  } else {
    debugPrint(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to updateAccount');
  }
}

Future<Account> createAccount(Account account) async {
  final response =
      await http.post(Uri.parse('$backendURL/$accountPath/$createPath/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(account.toJson()));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Account.fromJson(jsonDecode(response.body));
  } else {
    debugPrint(json.decode(response.body));
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to create Account');
  }
}
