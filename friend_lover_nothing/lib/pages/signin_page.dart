import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/DAO/account_dao.dart';
import 'package:friend_lover_nothing/application_config.dart';
import 'package:friend_lover_nothing/pages/event_swipe_page.dart';
import 'package:friend_lover_nothing/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode? _focusNode;
  bool _loggingIn = false;
  TextEditingController? _passwordController;
  TextEditingController? _usernameController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  child: Image.asset(
                    'assets/images/fln_logo.JPG',
                    height: 100,
                  )),
              Container(
                padding: const EdgeInsets.only(top: 80, left: 24, right: 24),
                child: Column(
                  children: [
                    TextField(
                      autocorrect: false,
                      autofillHints: _loggingIn ? null : [AutofillHints.email],
                      autofocus: true,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        label: const Text(
                          'Email',
                          semanticsLabel: "enter email",
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            semanticLabel: "clear email field",
                          ),
                          onPressed: () => _usernameController?.clear(),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () {
                        _focusNode?.requestFocus();
                      },
                      readOnly: _loggingIn,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        autocorrect: false,
                        autofillHints:
                            _loggingIn ? null : [AutofillHints.password],
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          label: const Text(
                            'Password',
                            semanticsLabel: "enter password",
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel,
                                semanticLabel: "clear password field"),
                            onPressed: () => _passwordController?.clear(),
                          ),
                        ),
                        focusNode: _focusNode,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        onEditingComplete: _login,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 163, 60, 60),
                            side:
                                const BorderSide(width: 2, color: Colors.black),
                            elevation: 5,
                            shadowColor: Colors.black),
                        onPressed: _loggingIn ? null : _login,
                        child: const Text(
                          'Login',
                          semanticsLabel: "log in button",
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side:
                                const BorderSide(width: 2, color: Colors.black),
                            elevation: 5,
                            shadowColor: Colors.black),
                        onPressed: _loggingIn
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Need an Account?',
                          semanticsLabel: "create account button",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

//handle log in action
  void _login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loggingIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController!.text,
        password: _passwordController!.text,
      );
      if (!mounted) return;
      globalAccountId = FirebaseAuth.instance.currentUser!.uid;
      globalAccount = fetchAccount(httpclient, globalAccountId);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SwipePage()));
    } catch (e) {
      setState(() {
        _loggingIn = false;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
          content: Text(
            e.toString(),
          ),
          title: const Text('Error'),
        ),
      );
    }
  }
}
