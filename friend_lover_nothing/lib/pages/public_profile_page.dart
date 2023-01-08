import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/widget/profile_image_widget.dart';

class PublicProfilePage extends StatefulWidget {
  final String title = 'Profile';
  final String accountId;

  const PublicProfilePage({super.key, required this.accountId});
  @override
  PublicProfilePageState createState() => PublicProfilePageState();
}

class PublicProfilePageState extends State<PublicProfilePage> {
  late Future<Account>? _account;

  @override
  void initState() {
    super.initState();
    _account = fetchAccount(httpclient, widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: FutureBuilder<Account>(
          future: _account,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data!;
              return Text(
                "${account.firstName} ${account.lastName}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              debugPrint('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: createProfile(),
      ),
    );
  }

  //create profile base on account
  Widget createProfile() {
    return FutureBuilder<Account>(
      future: _account,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return contentBuilder(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  //build profile content conditionally
  Widget contentBuilder(Account account) {
    debugPrint("contentBuilder executed");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileImage(isPublic: true, accountId: account.id),
        buildMemberSince(),
        //Basic profile
        buildSepartor("BASIC PROFILE"),
        buildUserInfoDisplay(
            "name", "${account.firstName} ${account.lastName}", Icons.person),
        customDivider(),
        buildUserInfoDisplay(
          "gender",
          account.gender,
          Icons.transgender_outlined,
        ),
        customDivider(),
        buildUserInfoDisplay(
          "personal link",
          account.link,
          Icons.public,
        ),
        customDivider(),
        buildUserInfoDisplay(
          "first interest",
          account.interest1,
          CupertinoIcons.heart_fill,
        ),
        customDivider(),
        buildUserInfoDisplay(
          "second interest",
          account.interest2,
          CupertinoIcons.heart_fill,
        ),
        customDivider(),
        buildUserInfoDisplay(
          "thirs interest",
          account.interest3,
          CupertinoIcons.heart_fill,
        ),
        customDivider(),
        buildUserInfoDisplay(
          "description",
          account.description,
          Icons.info,
        ),
      ],
    );
  }

  //build member since
  Widget buildMemberSince() => Container(
        alignment: Alignment.center,
        height: 30,
        child: const Text(
          "Member since Nov 2022",
          semanticsLabel: "Member since Nov 2022",
        ),
      );

  //build separator line
  Widget buildSepartor(String text) => Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      padding: const EdgeInsets.only(top: 10, bottom: 6, left: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Text(
        text,
        semanticsLabel: "$text section",
      ));

  // build section divider
  Divider customDivider() => Divider(
        thickness: 2.1,
        indent: MediaQuery.of(context).size.width * 0.08,
        endIndent: 0,
        height: 2.2,
        color: const Color.fromARGB(170, 139, 136, 136),
      );

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(
          String fieldName, String? getValue, IconData icon) =>
      Column(children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 10)),
          Icon(icon, size: 16),
          const Padding(padding: EdgeInsets.only(left: 6)),
          Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                Text(
                  getValue ?? "Update $fieldName",
                  semanticsLabel: "$fieldName: $getValue",
                  style: const TextStyle(
                      fontSize: 17, height: 0, color: Colors.black),
                ),
              ])),
        ]),
        const Padding(padding: EdgeInsets.only(top: 10)),
      ]);

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {
      _account = globalAccount;
    });
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
