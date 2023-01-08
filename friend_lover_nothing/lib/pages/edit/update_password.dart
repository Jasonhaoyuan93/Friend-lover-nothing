import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/widget/alert_dialog.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';

//update password of user
class UpdatePasswordWidget extends StatefulWidget {
  const UpdatePasswordWidget({super.key, required this.account});
  final Account account;
  @override
  State<UpdatePasswordWidget> createState() => _UpdatePasswordWidgetState();
}

class _UpdatePasswordWidgetState extends State<UpdatePasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> validateAndUpdatePassword(
      String oldPassword, String newPassword, String confirmNewPassword) async {
    if (oldPassword.isEmpty) {
      await createAlertDialog(context, "Please enter old password");
      return;
    }
    if (newPassword.isEmpty) {
      await createAlertDialog(context, "Please enter new password");
      return;
    }
    if (newPassword != confirmNewPassword) {
      await createAlertDialog(context, "New passwords mismatch");
      return;
    }

    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.account.email, password: oldPassword);
      } else {
        AuthCredential credential = EmailAuthProvider.credential(
            email: widget.account.email, password: oldPassword);
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);
      }
      FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await createAlertDialog(context, 'No user found for that email.');
        return;
      } else if (e.code == 'wrong-password') {
        await createAlertDialog(
            context, 'Wrong password provided for that user.');
        return;
      } else if (e.code == 'weak-password') {
        await createAlertDialog(
            context, 'Weak password, please use a strong password.');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 15)),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: TextFormField(
                    autocorrect: false,
                    autofocus: true,
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      label: const Text(
                        'Old Password',
                        semanticsLabel: "Enter Old Password",
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel, semanticLabel: "clear old password field"),
                        onPressed: () => oldPasswordController.clear(),
                      ),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: TextFormField(
                    autocorrect: false,
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      label: const Text(
                        'New Password',
                        semanticsLabel: "Enter New Password",
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel, semanticLabel: "clear new password field"),
                        onPressed: () => newPasswordController.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: TextFormField(
                    autocorrect: false,
                    controller: confirmNewPasswordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),label: const Text(
                        'Confirm New Password',
                        semanticsLabel: "Enter New Password again for confirm",
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel, semanticLabel: "clear confirmed password field",),
                        onPressed: () => confirmNewPasswordController.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                ElevatedButton(
                  onPressed: (() async {
                    validateAndUpdatePassword(
                        oldPasswordController.text,
                        newPasswordController.text,
                        confirmNewPasswordController.text);
                    Navigator.pop(context);
                  }),
                  child: const Text('Update Password', semanticsLabel: "Update Password Button"),
                ),
              ],
            ),
          ),
        ));
  }
}
