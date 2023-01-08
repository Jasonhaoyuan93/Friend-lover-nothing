import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'video.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/widget/profile_image_widget.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  late String? filePath;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() {
    if (_isRecording) {
      _cameraController.stopVideoRecording().then((file) {
        filePath = file.path;
        setState(() => _isRecording = false);
        Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => VideoPage(filePath: filePath!),
            )).then((value) {
          if (value) {
            Navigator.pop(context, filePath);
          }
        });
      });
      // ignore: use_build_context_synchronously
    } else {
      _cameraController
          .prepareForVideoRecording()
          .whenComplete(() => _cameraController.startVideoRecording())
          .whenComplete(() => setState(() => _isRecording = true));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_isRecording) {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(5),
              child: FloatingActionButton(
                backgroundColor: Colors.grey,
                child: const Icon(Icons.stop),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'assets/images/fln_logo.JPG',
            semanticLabel: "app logo",
            height: 30,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 35,
              semanticLabel: 'Back to swipe page',
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 3, top: 3),
                child: GestureDetector(
                  onTap: () {
                    _key.currentState!.openEndDrawer();
                  },
                  child: FutureBuilder(
                      future: globalAccount,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!.profileImageLocation == null
                              ? const Icon(
                                  Icons.person,
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
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You will record a short video introduction',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
                selectionColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => _recordVideo(),
                ),
              ),
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
}
