import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/DAO/applicantion_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/firebase_options.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:friend_lover_nothing/pages/application_approve_page.dart';
import 'package:friend_lover_nothing/pages/signin_page.dart';
import 'package:friend_lover_nothing/pages/public_profile_page.dart';

import 'chat.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({super.key});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  late Future<List<Application>> applications;
  late Stream<List<types.Room>> firebaseRooms;
  @override
  void initState() {
    applications = fetchApplications(httpclient, globalAccountId);
    firebaseRooms = FirebaseChatCore.instance.rooms();
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: true,
            title: SizedBox(
                child: Image.asset(
              'assets/images/fln_logo.JPG',
              height: 25,
            )),
            bottom: TabBar(
              padding: EdgeInsets.zero,
              tabs: [
                Tab(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.chat,
                      color: Colors.black,
                    ),
                    Padding(padding: EdgeInsets.only(left: 12)),
                    Text(
                      "Chat",
                      semanticsLabel: "chat tab",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )),
                Tab(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    Padding(padding: EdgeInsets.only(left: 12)),
                    Text(
                      "Tap",
                      semanticsLabel: "Tap tab",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ))
              ],
            ),
          ),
          body: SizedBox(
            height: 2000,
            child: TabBarView(
              children: [
                createChatList(context),
                createApplicationList(context)
              ],
            ),
          ),
        ));
  }

  Widget createChatList(context) {
    return _user == null
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not authenticated'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          )
        : StreamBuilder<List<types.Room>>(
            stream: firebaseRooms,
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: const Text('No rooms'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final room = snapshot.data![index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          final otherUser = room.users.firstWhere(
                            (u) => u.id != _user!.uid,
                          );
                          return FutureBuilder(
                              future: fetchAccount(httpclient, otherUser.id),
                              builder: (context, snapshot) {
                                debugPrint("chat room obtain user from aws");
                                if (snapshot.hasData) {
                                  return ChatPage(
                                      room: room, account: snapshot.data!);
                                } else if (snapshot.hasError) {
                                  return Text("error occur ${snapshot.error}");
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              });
                        }),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      FirebaseChatCore.instance
                                          .deleteRoom(room.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Yes',
                                      semanticsLabel: "yes button",
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No',
                                        semanticsLabel: "no button"),
                                  ),
                                ],
                                content: const Text(
                                  "Would you like to delete this chat",
                                  semanticsLabel:
                                      "Would you like to delete this chat",
                                ),
                                title: const Text(
                                  'Delete Chat',
                                  semanticsLabel: "Delete chat dialog",
                                ),
                              ));
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: _buildAvatar(room)),
                  );
                },
              );
            },
          );
  }

  Widget createApplicationList(context) {
    return FutureBuilder(
      future: applications,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final application = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return ApplicationApprovePage(application: application);
                  }))).then((value) {
                    onGoBack(value);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildApplicationAvatar(application),
                      Text(
                          "${application.account.firstName} ${application.account.lastName}"),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          throw Exception(snapshot.error);
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (mounted) {
          setState(() {
            _user = user;
          });
        }
      });
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
        });
      }
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    types.User otherUser = room.users.firstWhere(
      (u) => u.id != _user!.uid,
    );
    Future<Account> publicAccount =
        fetchPublicAccount(httpclient, otherUser.id);

    return FutureBuilder<Account>(
        future: publicAccount,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return PublicProfilePage(accountId: otherUser.id);
                    })));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: snapshot.data!.profileImageLocation == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                snapshot.data!.profileImageLocation!),
                            radius: 20,
                          ),
                  ),
                ),
                Text(
                  "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                  semanticsLabel:
                      "start chat with ${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("error occur ${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _buildApplicationAvatar(Application application) {
    var color = Colors.transparent;

    final hasImage = application.account.profileImageLocation != null;
    final name =
        "${application.account.firstName} ${application.account.lastName}";

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return PublicProfilePage(accountId: application.account.id);
        })));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: CircleAvatar(
          backgroundColor: hasImage ? Colors.transparent : color,
          backgroundImage: hasImage
              ? NetworkImage(application.account.profileImageLocation!)
              : null,
          radius: 20,
          child: !hasImage
              ? Text(
                  name.isEmpty ? '' : name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
      ),
    );
  }

  FutureOr onGoBack(value) async {
    setState(() {
      debugPrint("");
      applications = fetchApplications(httpclient, globalAccountId);
    });
  }
}
