/*
Sign up page

This page is used for signup and authentification. The ui is a basic form and 
the data is connected with our backend as well as firebase.

Author:Sonam Shrestha 
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/model/account.dart';
import 'package:friend_lover_nothing/pages/event_swipe_page.dart';
import 'package:friend_lover_nothing/widget/alert_dialog.dart';
import '../model/form_data_signup.dart';

/// Signup page class
/// This class has the build method that connects to the formData and
/// feeds all inputs to the variables in the formdata
/// The second method is the handlesignup method that connects with
/// firebase and assigns the values to the account model.

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    FormData formData = FormData();

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  child: Image.asset(
                    'assets/images/fln_logo.JPG',
                    height: 45,
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: const Text(
                    "Create an Account!",
                    style: TextStyle(fontSize: 24),
                    semanticsLabel: "creat account page",
                  )),

              //form with basic profile information
              Form(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...[
                          TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text(
                                  'First Name',
                                  semanticsLabel:
                                      "Enter your first name, required",
                                ),
                              ),
                              onChanged: (value) {
                                formData.firstName = value;
                              },
                              textInputAction: TextInputAction.next),
                          TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text(
                                  'Last Name',
                                  semanticsLabel:
                                      "Enter your last name, required",
                                ),
                              ),
                              onChanged: (value) {
                                formData.lastName = value;
                              },
                              textInputAction: TextInputAction.next),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Your email address',
                              label: Text(
                                'Email',
                                semanticsLabel: "Enter email, required",
                              ),
                            ),
                            onChanged: (value) {
                              formData.email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text(
                                  'Password',
                                  semanticsLabel: "Enter password, required",
                                ),
                              ),
                              obscureText: true,
                              onChanged: (value) {
                                formData.password = value;
                              },
                              textInputAction: TextInputAction.next),
                          TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text(
                                  'Required: Age',
                                  semanticsLabel: "Enter Age, required",
                                ),
                              ),
                              onChanged: (value) {
                                formData.age = int.tryParse(value);
                              },
                              textInputAction: TextInputAction.done),
                          TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                label: Text(
                                  'Optional: Phone Number',
                                  semanticsLabel:
                                      "Enter Phone number, optional",
                                ),
                              ),
                              onChanged: (value) {
                                formData.phoneNumber = value;
                              },
                              textInputAction: TextInputAction.done),
                          // button that will initiate the signup and call
                          // handle sign up
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          ElevatedButton(
                              child: const Text(
                                'Sign up',
                                semanticsLabel: "Sign up button",
                              ),
                              onPressed: () async {
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 3),
                                  content: Row(
                                    children: const <Widget>[
                                      CircularProgressIndicator(),
                                      Text("  Signing Up...")
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                await handleSignUp(context, formData);

                                //_onLoading();
                              }),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> handleSignUp(context, FormData formData) async {
    //creates a new user in firebase
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: formData.email!,
        password: formData.password!,
      );
      //the account information is assigned
      Account account = Account(
          id: FirebaseAuth.instance.currentUser!.uid,
          firstName: formData.firstName!,
          lastName: formData.lastName!,
          email: formData.email!,
          age: formData.age,
          phone: formData.phoneNumber);
      //create account is called
      await createAccount(account);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          id: FirebaseAuth.instance.currentUser!.uid,
        ),
      );
      isLoggedIn = true;
      globalAccountId = FirebaseAuth.instance.currentUser!.uid;
      globalAccount = globalAccount = fetchAccount(httpclient, globalAccountId);
      //once logged in, the user will be lead to the homepage
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SwipePage()));
    }
    //if there is an error, we prompt the user with the following errors
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        createAlertDialog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        createAlertDialog(
            context, 'The account already exists for that email.');
      }
    } catch (e) {
      FirebaseAuth.instance.signOut();
      createAlertDialog(context, e.toString());
    }
  }
}
