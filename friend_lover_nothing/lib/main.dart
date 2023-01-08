import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/pages/event_swipe_page.dart';
import 'package:friend_lover_nothing/pages/signin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkIfSignedIn(context);
    return const MaterialApp(
        title: 'Friend, Lover, Nothing',
        debugShowCheckedModeBanner: false,
        home: HomePage(
          title: 'Friend, Lover, Nothing',
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    checkIfSignedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: handletSartPage(context));
  }
}

Widget handletSartPage(context) {
  //build first page base on if loggedIn
  if (!isLoggedIn) {
    return const LoginPage();
  }
  return const SwipePage();
}

void checkIfSignedIn(context) {
  if (FirebaseAuth.instance.currentUser != null) {
    //update global var if already signed in
    isLoggedIn = true;
    globalAccountId = FirebaseAuth.instance.currentUser!.uid;
    globalAccount = fetchAccount(httpclient, globalAccountId);
  }
}
