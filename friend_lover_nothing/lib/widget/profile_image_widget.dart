import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';

import 'image_pick_dialog.dart';

class ProfileImage extends StatefulWidget {
  // Constructor
  final bool isPublic;
  final String accountId;
  const ProfileImage({Key? key, this.isPublic = false, required this.accountId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ProfileImageState();
}

class ProfileImageState extends State<ProfileImage> {
  late Future<Account> _account;

  @override
  void initState() {
    _account = fetchAccount(httpclient, widget.accountId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _account,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child: buildImage(snapshot.data!));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  // Builds Profile Image
  Widget buildImage(Account account) {
    //public with photo
    if (widget.isPublic && account.profileImageLocation != null) {
      return Stack(children: [
        CachedNetworkImage(
          imageUrl: account.profileImageLocation!,
          imageBuilder: (context, imageProvider) => Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ]);
    } else if (!widget.isPublic && account.profileImageLocation == null) {
      //private without photo
      return CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          child: IconButton(
            iconSize: 75,
            alignment: Alignment.center,
            onPressed: (() async {
              await imageUploadDialog(context, account);
              setState(() {
                _account = globalAccount!;
              });
            }),
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              shadows: [Shadow(color: Colors.grey)],
              semanticLabel: "profile image",
            ),
          ));
    } else if (!widget.isPublic && account.profileImageLocation != null) {
      //private with photo
      return Stack(children: [
        CachedNetworkImage(
          imageUrl: account.profileImageLocation!,
          imageBuilder: (context, imageProvider) => Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: buildEditIcon(context, account),
        ),
      ]);
    } else {
      //public without photo
      return const CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            color: Colors.white,
            shadows: [Shadow(color: Colors.grey)],
            semanticLabel: "profile image",
          ));
    }
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(context, Account account) => buildCircle(
      all: 0,
      child: IconButton(
        iconSize: 25,
        icon: const Icon(
          Icons.edit,
          color: Color.fromRGBO(64, 105, 225, 1),
          semanticLabel: "edit profile image button",
        ),
        onPressed: () async {
          await imageUploadDialog(context, account);
          setState(() {
            _account = globalAccount!;
          });
        },
      ));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}
