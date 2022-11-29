import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future wrongPasswordPopUp() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Wrong userinfo...'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/login_page'));
                      },
                      child: const Text('Go Back')),
                ],
              )
            ],
          ));
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  String userMail = '';
  String userPassword = '';

  //List<UserInfo> users = List.from(UserDataBase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () {
                  //
                },
                icon: const Icon(
                  Icons.help,
                  size: 45,
                )),
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [(Colors.indigo), (Colors.indigoAccent)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            //Hello again!
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientText(
                'Hello Again!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [(Colors.indigoAccent), (Colors.indigo)],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientText(
                "Welcome back, you've been missed!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [(Colors.indigoAccent), (Colors.indigo)],
              ),
            ),
            //email textfield
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _emailTextController.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _emailTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //password textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontSize: 20),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _passwordTextController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    controller: _passwordTextController,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [(Colors.indigo), (Colors.indigoAccent)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(20),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      userMail = _emailTextController.text;
                      userPassword = _passwordTextController.text;
                    });
                    try {
                      await loginUser(userMail, userPassword);
                    } catch (BackendException) {
                      print('Error occurred $BackendException');
                      return;
                    }
                    Navigator.pushNamed(context, '/home');
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            //not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not a member? '),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(String emailUser, String passwordUser) async {
    Map<String, dynamic> body = {
      'email': emailUser,
      'password': passwordUser,
    };
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.postLoginUser,
      body: body,
      useAuthToken: false,
    );
    // Contains a list of the format [User, String].
    List userResponse = await NetworkHelper.filterResponse(
      callBack: User.loginUserFromJson,
      response: response,
    );

    // Store the authToken in the Shared Preferences.
    final pref = await SharedPreferences.getInstance();
    await pref.setString('authToken', userResponse[1]);

    // Store the user model in the Provider.
    if (mounted) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userResponse[0]);
    }
  }
}
