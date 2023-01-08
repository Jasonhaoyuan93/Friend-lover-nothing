import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/pages/messaging_page.dart';
import 'package:friend_lover_nothing/widget/profile_image_widget.dart';

AppBar buildAppBar(BuildContext context) {
  //create app bar
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    title: SizedBox(
        child: Image.asset(
      'assets/images/fln_logo.JPG',
      height: 25,
    )),
    iconTheme: const IconThemeData(color: Colors.black),
    elevation: 0,
  );
}

AppBar buildGeneralAppBar(context, key, {bool enableBack = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: true,
    title: SizedBox(
        child: Image.asset(
      'assets/images/fln_logo.JPG',
      semanticLabel: "app logo",
      height: 30,
    )),
    leading: !enableBack
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return const MessagingPage();
              })));
            },
            child: const Icon(
              Icons.chat,
              color: Colors.black,
              size: 50.0,
              semanticLabel: 'Leads to messages and matches',
            ),
          )
        : BackButton(
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
    actions: <Widget>[
      Padding(
          padding: const EdgeInsets.only(right: 12.0, bottom: 3, top: 3),
          child: GestureDetector(
            onTap: () {
              key.currentState!.openEndDrawer();
            },
            child: FutureBuilder(
                future: globalAccount,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.profileImageLocation == null
                        ? const Icon(
                            Icons.person,
                            semanticLabel: "profile picture",
                            color: Colors.black,
                            size: 50.0,
                          )
                        : FittedBox(
                            fit: BoxFit.contain,
                            child: ProfileImage(
                              isPublic: true,
                              accountId: globalAccountId,
                            ),
                          );
                  } else if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                })),
          )),
    ],
  );
}
