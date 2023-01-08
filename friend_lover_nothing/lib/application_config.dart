library globals;

import 'package:friend_lover_nothing/model/account.dart';
import 'package:http/http.dart' as http;

//APIs
const String backendURL =
    'http://friendlovernothing-env.eba-k3s95vum.us-west-2.elasticbeanstalk.com';
const String accountPath = 'account';
const String eventPath = 'event';
const String applicationPath = 'application';
const String ownerPath = 'owner';
const String closeApplicationPath = 'closeApplication';
const String updatePath = 'update';
const String createPath = 'create';

//shared resources
http.Client httpclient = http.Client();

//User Data
String globalAccountId = "";
bool isLoggedIn = false;
Future<Account>? globalAccount;
