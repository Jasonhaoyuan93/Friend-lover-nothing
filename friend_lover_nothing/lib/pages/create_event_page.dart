/*
Create Event Page

This page will be used to post the event details like image, title, description.
Once we have the information, we will post it to the backend.

Author:Sonam Shrestha 
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/event_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/model/event_image.dart';
import 'package:friend_lover_nothing/pages/camera.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';
import 'package:friend_lover_nothing/widget/menu.dart';
import 'package:image_picker/image_picker.dart';

/// Documentation
/// This class has one big body and another helper method for the assignment
/// of event details to our backend.
/// This class calls the event form and different event models inorder to make
/// the assigment possible of the images to our backend and to later be able to
/// call them in the homepage.

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  //create instance of form data to initialize empty lists for the images and
  // descriptions
  late Future<Account>? _account;
  // this is the counter for the final save and post button
  // it only pops up if the counter is nonzero
  int counter = 0;
  // this is the boolean to pop or hide the upload image button
  bool imageUploaded = false;
  // the image that will be displayed of the event
  File? displayImage;
  String? displayImageDescription;
  File? videoFile;
  List<ImageDescriptionPair> imageDescriptionPairList =
      List.empty(growable: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _account = globalAccount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar
        key: scaffoldKey,
        endDrawer: const Menu(),
        appBar: buildGeneralAppBar(context, scaffoldKey, enableBack: true),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: const Text(
                  "Create your Event!",
                  style: TextStyle(fontSize: 24),
                )),
            Form(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...[
                        // simple textform for title and description
                        TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              labelText: 'Event Title',
                            ),
                            textInputAction: TextInputAction.done),
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        createImageUploadComponent(displayImage),
                        const Padding(padding: EdgeInsets.only(top: 35)),
                        SizedBox(
                            height: 140,
                            width: MediaQuery.of(context).size.width - 12,
                            child: TextFormField(
                              maxLength: 150,
                              expands: true,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (value) {
                                // description gets posted to the list
                                displayImageDescription = value;
                              },
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  hintMaxLines: 3,
                                  hintText:
                                      'Write a little about this event. Anything fun? Any excitement?'),
                            )),
                      ],
                      //display uploaded additional images
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 7),
                        child: autoPopulatedAdditionalImage(),
                      ),

                      addAdditionalImage(),
                      // display record self intro video button or upload button
                      Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 25),
                          child: nextActionButton()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )));
  }

  // image upload only appears if there is no image currently
  // posted
  Widget createImageUploadComponent(File? image, {bool isStandalone = true}) {
    return Container(
        color: Colors.black,
        height: isStandalone ? 150 : 100,
        width: isStandalone
            ? MediaQuery.of(context).size.width - 12
            : MediaQuery.of(context).size.width * 0.3 - 12,
        child: image == null
            ? IconButton(
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                ),
                iconSize: isStandalone ? 100 : 60,
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            SimpleDialogOption(
                                onPressed: () async {
                                  // image picker for the gallery
                                  await ImagePicker()
                                      .getImage(source: ImageSource.gallery)
                                      .then((image) {
                                    if (image != null) {
                                      // image gets pushed to the
                                      // event files
                                      displayImage = File(image.path);
                                      imageUploaded = true;
                                    }

                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("Phone Library")),
                            SimpleDialogOption(
                                onPressed: () async {
                                  await ImagePicker()
                                      .getImage(source: ImageSource.camera)
                                      .then((image) {
                                    if (image != null) {
                                      // image gets pushed to the
                                      // event files
                                      displayImage = File(image.path);
                                      imageUploaded = true;
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("Take Photo")),
                            SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                          ],
                        );
                      });
                  setState(() {});
                },
              )
            : isStandalone
                ? Image.file(image, height: 150)
                : Image.file(
                    image,
                    width: MediaQuery.of(context).size.width * 0.4 - 16,
                  ));
  }

  Widget autoPopulatedAdditionalImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          itemCount: imageDescriptionPairList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                  height: 120,
                  child: TextFormField(
                    maxLength: 100,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      // description gets posted to the list
                      imageDescriptionPairList[index].discription = value;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.only(top: 6, right: 2),
                        prefixIcon: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: createImageUploadComponent(
                                imageDescriptionPairList[index].imageFile,
                                isStandalone: false)),
                        hintMaxLines: 2,
                        hintText: 'what about this image?'),
                  )),
            );
          },
        )
      ],
    );
  }

  Widget addAdditionalImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Upload additional image"),
        IconButton(
          icon: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.black,
          ),
          iconSize: 60,
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    children: <Widget>[
                      SimpleDialogOption(
                          onPressed: () async {
                            // image picker for the gallery
                            await ImagePicker()
                                .getImage(source: ImageSource.gallery)
                                .then((image) {
                              if (image != null) {
                                imageDescriptionPairList.add(
                                    ImageDescriptionPair(
                                        imageFile: File(image.path)));
                              }
                              Navigator.pop(context);
                            });
                          },
                          child: const Text("Phone Library")),
                      SimpleDialogOption(
                          onPressed: () async {
                            await ImagePicker()
                                .getImage(source: ImageSource.camera)
                                .then((image) {
                              if (image != null) {
                                imageDescriptionPairList.add(
                                    ImageDescriptionPair(
                                        imageFile: File(image.path)));
                              }
                              Navigator.pop(context);
                            });
                          },
                          child: const Text("Take Photo")),
                      SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                    ],
                  );
                });
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget nextActionButton() =>
      // Video record button
      videoFile == null || displayImage == null
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  side: const BorderSide(width: 2, color: Colors.black),
                  elevation: 5,
                  shadowColor: Colors.black),
              onPressed: () => showDialog<String>(
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
                        }))).then((value) {
                          if (value != null) {
                            setState(() {
                              videoFile = File(value);
                            });
                          }
                        }).whenComplete(() => Navigator.pop(context));
                      },
                      child: const Text('Go to video!'),
                    ),
                  ],
                ),
              ),
              child: const Text(
                'Record Video Introduction',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : FutureBuilder<Account>(
              future: _account,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ElevatedButton(
                      onPressed: () {
                        List<EventImage> imageDescriptions =
                            List.empty(growable: true);
                        List<File> images = List.empty(growable: true);
                        images.add(displayImage!);
                        imageDescriptions.add(EventImage(
                            imageDescription: displayImageDescription ?? ""));
                        for (var element in imageDescriptionPairList) {
                          images.add(element.imageFile!);
                          imageDescriptions.add(EventImage(
                              imageDescription: element.discription ?? ""));
                        }
                        handleEvent(snapshot.data!, imageDescriptions, images,
                            videoFile);
                        Navigator.pop(context);
                      },
                      child: const Text("Save Event and Post!"));
                } else {
                  return const CircularProgressIndicator();
                }
              });
}

void handleEvent(account, eventImages, images, videoFile) async {
  Event event = Event(account: account, eventImages: eventImages);
  await createEvents(event, videoFile, images);
}

class ImageDescriptionPair {
  String? discription;
  File? imageFile;

  ImageDescriptionPair({this.discription, this.imageFile});
}
