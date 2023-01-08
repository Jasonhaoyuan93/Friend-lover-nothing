import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/widget/appbar_widget.dart';
import 'package:string_validator/string_validator.dart';

// This class handles the Page to edit the all other Sections of the User Profile.
class EditTxtFormPage extends StatefulWidget {
  const EditTxtFormPage(
      {Key? key, required this.fieldToBeChanged, required this.accountCopy})
      : super(key: key);

  final String fieldToBeChanged;
  final Account accountCopy;

  @override
  EditTxtFormPageState createState() {
    return EditTxtFormPageState();
  }
}

class EditTxtFormPageState extends State<EditTxtFormPage> {
  final _formKey = GlobalKey<FormState>();
  final txtController = TextEditingController();

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  void updateUserValue(String value) {
    switch (widget.fieldToBeChanged) {
      case "link":
        widget.accountCopy.link = value;
        break;
      case "description":
        widget.accountCopy.description = value;
        break;
      case "phone":
        String formattedPhoneNumber =
            "(${value.substring(0, 3)}) ${value.substring(3, 6)}-${value.substring(6, value.length)}";
        widget.accountCopy.phone = formattedPhoneNumber;
        break;
      case "gender":
        widget.accountCopy.gender = value;
        break;
      case "age":
        widget.accountCopy.age = int.parse(value);
        break;
      case "interest1":
        widget.accountCopy.interest1 = value;
        break;
      case "interest2":
        widget.accountCopy.interest2 = value;
        break;
      case "interest3":
        widget.accountCopy.interest3 = value;
        break;
      default:
        throw Exception("No Such Option");
    }
    globalAccount = updateAccount(widget.accountCopy, null);
  }

  String? validateInput(String? value) {
    debugPrint("validated");
    if (value == null || value.isEmpty) {
      return 'Please enter your ${widget.fieldToBeChanged}.';
    }

    if (widget.fieldToBeChanged == "phone" &&
        (!isNumeric(value) || value.length < 10 || value.length > 28)) {
      return 'Please enter valid only number phone number.';
    }

    if (widget.fieldToBeChanged == "link" && !isURL(value)) {
      return 'Please enter valid url.';
    }

    if (widget.fieldToBeChanged == "description" && value.length > 200) {
      return 'Please describe yourself but keep it under 200 characters.';
    }

    return null;
  }

  Widget createTextFormField(String value) {
    if (value == "description") {
      return SizedBox(
          height: 250,
          width: 350,
          child: TextFormField(
            // Handles Form Validation
            validator: (value) {
              return validateInput(value as String);
            },
            maxLength: 200,
            maxLines: 7,
            controller: txtController,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 100),
                hintMaxLines: 3,
                hintText:
                    'Write a little bit about yourself. Do you like chatting? Are you a smoker? Do you bring pets with you? Etc.'),
          ));
    }
    return TextFormField(
      // Handles Form Validation
      validator: (value) {
        return validateInput(value as String);
      },
      decoration: InputDecoration(labelText: 'Your ${widget.fieldToBeChanged}'),
      controller: txtController,
    );
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
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  SizedBox(
                      width: 320,
                      child: Text(
                        "Please enter new ${widget.fieldToBeChanged}",
                        semanticsLabel: "Please enter new ${widget.fieldToBeChanged}",
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                          height: 250,
                          width: 320,
                          child: createTextFormField(widget.fieldToBeChanged))),
                  Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 320,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                debugPrint("Pressed");
                                if (_formKey.currentState!.validate()) {
                                  debugPrint("to This locations");
                                  updateUserValue(txtController.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Update',
                                semanticsLabel: "Update button",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          )))
                ]),
          ),
        ));
  }
}
