import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:image_picker/image_picker.dart';

Future<void> imageUploadDialog(context, account) async {
  //create image upload Dialog
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
                onPressed: () async {
                  await ImagePicker()
                      .getImage(source: ImageSource.gallery)
                      .then((value) {
                    var image = value;
                    if (image != null) {
                      globalAccount = updateAccount(account, File(image.path));
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text("Phone Library", semanticsLabel: "choose photo from photo library",)),
            SimpleDialogOption(
                onPressed: () async {
                  await ImagePicker()
                      .getImage(source: ImageSource.camera)
                      .then((value) {
                    var image = value;
                    if (image != null) {
                      globalAccount = updateAccount(account, File(image.path));
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text("Take Photo", semanticsLabel: "take photo now",)),
            SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel", semanticsLabel: "cancel",)),
          ],
        );
      });
}
