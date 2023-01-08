import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/applicantion_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/pages/camera.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';
import 'package:friend_lover_nothing/widget/menu.dart';
import 'package:video_player/video_player.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key, required this.event});
  final Event event;
  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late VideoPlayerController controller;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(widget.event.videoLocation!);
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawer: const Menu(),
      appBar: buildGeneralAppBar(context, _key, enableBack: true),
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ],
            ),
          ),
        ),
        VideoProgressIndicator(controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              backgroundColor: Colors.grey,
              playedColor: Colors.black,
              bufferedColor: Colors.purple,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.all(15),
              onPressed: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }

                setState(() {});
              },
              icon: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle_outline_outlined
                    : Icons.play_arrow,
                size: 30,
                semanticLabel: "Play or Pause button",
              ),
            ),
            IconButton(
                padding: const EdgeInsets.all(15),
                onPressed: () {
                  controller.seekTo(const Duration(seconds: 0));

                  setState(() {});
                },
                icon: const Icon(
                  Icons.stop,
                  size: 30,
                  semanticLabel: "stop playing",
                )),
            const Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
              size: 35,
              semanticLabel: "back to event page",
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.65)),
          selfIntroVideoUploadButton()
        ])
      ]),
    );
  }

  Widget selfIntroVideoUploadButton() {
    return IconButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Awesome, Time to record your intro!'),
              content: const Text('Relax, and dont froget to be yourself!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Back'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return const CameraPage();
                    }))).then((value) async {
                      if (value != null) {
                        File videoFile = File(value);
                        handleCreateApplication(
                            await globalAccount!, widget.event, videoFile);
                      }
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text('Go to video!'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(
          Icons.thumb_up,
          color: Colors.pink,
          size: 35,
          semanticLabel: "like button, be ready to self record",
        ));
  }

  void handleCreateApplication(Account account, Event event, File videoFile) {
    createApplication(Application(account: account, event: event), videoFile);
  }
}
