/*
Event Page - Homepage

This page is used for signup and authentification. The ui is a basic form and 
the data is connected with our backend as well as firebase.
Author (version 1): Sonam Shrestha
Author (final version): Hao Yuan
*/

import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/event_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/widget/alert_dialog.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';
import 'package:friend_lover_nothing/widget/menu.dart';
import 'package:friend_lover_nothing/widget/tictok_scroll.dart';
import 'create_event_page.dart';

/// Swipe Page Class
/// This class calls the events from the backend and displays them on the screen
/// users can scroll and swipe as a means to interract with the post.

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  SwipePageState createState() => SwipePageState();
}

class SwipePageState extends State<SwipePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int currentPage = 0;
  late Future<List<Event>> eventData;

  @override
  void initState() {
    eventData = fetchEvents(httpclient, globalAccountId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        endDrawer: const Menu(),
        appBar: buildGeneralAppBar(context, _key),
        extendBodyBehindAppBar: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Builder(builder: (context) {
            debugPrint("Swipe Page Builded");
            return ListView(
              children: [
                Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                      child: FutureBuilder(
                    future: eventData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // if there is events in the database, we will
                        // post them. The tictok scroll has been imported and
                        // used
                        return TictokScroll(eventData: snapshot.data!);
                      } else if (snapshot.hasError) {
                        createAlertDialog(context, snapshot.error.toString());
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02)),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2 - 47)),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CreateEventPage()));
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 32.0,
                        semanticLabel: "Create event button",
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 2 - 147)),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          eventData = fetchEvents(httpclient, globalAccountId);
                          debugPrint("refreshed");
                        });
                      },
                      elevation: 0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.refresh,
                        size: 32.0,
                        semanticLabel: "Refresh event button",
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ));
  }
}
