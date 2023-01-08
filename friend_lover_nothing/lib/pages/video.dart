import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? chewieController;

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    if (chewieController != null) {
      chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            debugPrint('Video Not Good');
            Navigator.pop(context, false);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              debugPrint('Video shot finished');
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: false,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
                child: Column(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(_videoPlayerController),
                        VideoProgressIndicator(_videoPlayerController,
                            allowScrubbing: true,
                            padding: const EdgeInsets.all(2.0)), //Icon
                        IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              if (_videoPlayerController.value.isPlaying) {
                                _videoPlayerController.pause();
                              } else {
                                _videoPlayerController.play();
                              }
                            }) //Icon
                      ],
                    ),
                  ))
            ]));
          }
        },
      ),
    );
  }
}
