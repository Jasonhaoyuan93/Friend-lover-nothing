import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/main.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/pages/private_profile_page.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State<Menu> {
  late Future<Account>? _account;

  @override
  void initState() {
    super.initState();
    _account = globalAccount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Account>(
      future: _account,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return createView(context, snapshot.data!);
        } else if (snapshot.hasError) {
          throw Exception("account not loaded");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

Widget createView(context, Account account) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.07)),
        Stack(alignment: Alignment.center, children: [
          account.profileImageLocation == null
              ? const Icon(
                  Icons.person_rounded,
                  semanticLabel: "picture of user",
                )
              : CachedNetworkImage(
                  imageUrl: account.profileImageLocation!,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
        ]),
        const SizedBox(height: 20),
        SizedBox(
            width: 40,
            child: Text(
              "${account.firstName} ${account.lastName}",
              textAlign: TextAlign.center,
              semanticsLabel:
                  "The name of user is ${account.firstName} ${account.lastName}",
            )),
        ListTile(
          leading: const Icon(
            Icons.person,
          ),
          title: const Text(
            'Profile',
            semanticsLabel: "Go to private profile page",
          ),
          onTap: () {
            // Update the state of the app
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return const PrivateProfilePage();
            })));
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.info,
          ),
          title: const Text(
            'About',
            semanticsLabel: "go to the about application page",
          ),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.phone,
          ),
          title: const Text(
            'Contact Support',
            semanticsLabel: "call contact support",
          ),
          onTap: () {
            debugPrint("make phone call to support");
            Navigator.pop(context);
          },
        ),
        ListTile(
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text(
              'Logout',
              semanticsLabel: "log out button",
            ),
            onTap: (() async {
              await FirebaseAuth.instance.signOut().whenComplete(() {
                isLoggedIn = false;
                globalAccount = null;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            const HomePage(title: "Friend, lover, nothing")),
                    (route) => false);
              });
            })),
      ],
    ),
  );
}
