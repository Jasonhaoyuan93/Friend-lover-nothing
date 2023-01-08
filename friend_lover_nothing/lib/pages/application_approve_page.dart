import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:friend_lover_nothing/DAO/applicantion_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/application.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';
import 'package:friend_lover_nothing/widget/menu.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ApplicationApprovePage extends StatefulWidget {
  const ApplicationApprovePage({super.key, required this.application});
  final Application application;
  @override
  State<ApplicationApprovePage> createState() => _ApplicationApprovePageState();
}

class _ApplicationApprovePageState extends State<ApplicationApprovePage> {
  late VideoPlayerController controller;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late Application _application;
  @override
  void initState() {
    _application = widget.application;
    loadVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  loadVideoPlayer() {
    controller = VideoPlayerController.network(
        widget.application.cloudVideoFileLocation!);
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
      appBar: buildGeneralAppBar(context, _key),
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
                  semanticLabel: "Play or Pause button",
                )),
            const Padding(padding: EdgeInsets.only(right: 10))
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          IconButton(
            onPressed: () {
              _application.approved = false;
              _application.closed = true;
              closeApplications(httpclient, _application)
                  .whenComplete(() => Navigator.pop(context));
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
              semanticLabel: "refuse and leave button",
              size: 35,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.65)),
          IconButton(
            onPressed: () {
              _application.approved = true;
              _application.closed = true;
              createChatRoom(_application, context);
              closeApplications(httpclient, _application)
                  .whenComplete(() => Navigator.pop(context));
            },
            icon: const Icon(
              Icons.thumb_up,
              color: Colors.pink,
              size: 35,
              semanticLabel: "approve button, will start chat",
            ),
          ),
        ])
      ]),
    );
  }

  void createChatRoom(Application application, BuildContext context) async {
    await FirebaseChatCore.instance
        .createRoom(types.User(id: application.account.id));
  }
}
