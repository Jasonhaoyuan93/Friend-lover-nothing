import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/main.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/pages/edit/edit_name.dart';
import 'package:friend_lover_nothing/pages/edit/edit_txt.dart';
import 'package:friend_lover_nothing/pages/edit/update_password.dart';
import 'package:friend_lover_nothing/widget/profile_image_widget.dart';

class PrivateProfilePage extends StatefulWidget {
  final String title = 'Profile';
  const PrivateProfilePage({super.key});
  @override
  PrivateProfilePageState createState() => PrivateProfilePageState();
}

class PrivateProfilePageState extends State<PrivateProfilePage> {
  late Future<Account>? _account;

  @override
  void initState() {
    super.initState();
    _account = globalAccount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: createProfile(),
      ),
    );
  }

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

  //build profile page content
  Widget contentBuilder(Account account) {
    debugPrint("contentBuilder executed");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileImage(accountId: globalAccountId),
        buildMemberSince(),
        //Basic profile
        buildSepartor("BASIC PROFILE"),
        buildUserInfoDisplay("name", "${account.firstName} ${account.lastName}",
            Icons.person, EditNameFormPage(account: Account.clone(account))),
        customDivider(),
        buildUserInfoDisplay(
            "gender",
            account.gender,
            Icons.transgender_outlined,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "gender",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "personal link",
            account.link,
            Icons.public,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "link",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "first interest",
            account.interest1,
            CupertinoIcons.heart_fill,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "interest1",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "second interest",
            account.interest2,
            CupertinoIcons.heart_fill,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "interest2",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "thirds interest",
            account.interest3,
            CupertinoIcons.heart_fill,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "interest3",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "description",
            account.description,
            Icons.info,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "description",
            )),
        //Private Information
        buildSepartor("PRIVATE INFORMATION"),
        buildUserInfoDisplay(
            "email",
            account.email,
            Icons.email_outlined,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "email",
            )),
        customDivider(),
        buildUserInfoDisplay(
            "phone number",
            account.phone,
            Icons.phone_android_outlined,
            EditTxtFormPage(
              accountCopy: Account.clone(account),
              fieldToBeChanged: "phone",
            )),

        buildSepartor("CREDENTIAL"),
        const Padding(padding: EdgeInsets.only(top: 15)),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: 35,
            child: ElevatedButton(
                onPressed: () {
                  navigateSecondPage(UpdatePasswordWidget(
                    account: account,
                  ));
                },
                child: const Text(
                  "Update Password",
                  semanticsLabel: "Update Password Button",
                ))),
        const Padding(padding: EdgeInsets.only(top: 25)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: 35,
          child: ElevatedButton(
              onPressed: (() async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  isLoggedIn = false;
                  globalAccount = null;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const HomePage(title: "Friend, lover, nothing")),
                      (route) => false);
                });
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  side: const BorderSide(width: 2, color: Colors.black),
                  elevation: 5,
                  shadowColor: Colors.black),
              child: const Text("Log Out", semanticsLabel: "Log Out Button")),
        ),
        const Padding(padding: EdgeInsets.only(top: 50)),
      ],
    );
  }

  Widget buildMemberSince() => Container(
        alignment: Alignment.center,
        height: 30,
        child: const Text("Member since Nov 2022"),
      );

  Widget buildSepartor(String text) => Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      padding: const EdgeInsets.only(top: 10, bottom: 6, left: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Text(
        text,
      ));

  Divider customDivider() => Divider(
        thickness: 2.1,
        indent: MediaQuery.of(context).size.width * 0.08,
        endIndent: 0,
        height: 2.2,
        color: const Color.fromARGB(170, 139, 136, 136),
      );

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(
          String fieldName, String? getValue, IconData icon, Widget editPage) =>
      Flexible(
          child: Row(children: <Widget>[
        const Padding(padding: EdgeInsets.only(left: 10)),
        Icon(icon, size: 16),
        const Padding(padding: EdgeInsets.only(left: 6)),
        Flexible(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              TextButton(
                onPressed: () {
                  if (icon != Icons.email_outlined) {
                    navigateSecondPage(editPage);
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 7, bottom: 7),
                  minimumSize: const Size(50, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  getValue ?? "Tap to update $fieldName",
                  semanticsLabel: "Tap to update $fieldName",
                  style: const TextStyle(
                      fontSize: 15, height: 0, color: Colors.black),
                ),
              ),
            ])),
      ]));

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
