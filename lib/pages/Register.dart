import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register_Now extends StatefulWidget {
  const Register_Now({Key? key}) : super(key: key);

  @override
  State<Register_Now> createState() => _Register_NowState();
}

class _Register_NowState extends State<Register_Now> {
  final _FirstNameR_textcontroller = TextEditingController();
  final _LastNameR_textcontroller = TextEditingController();
  final _EmailR_textcontroller = TextEditingController();
  final _PasswordR_textcontroller = TextEditingController();
  final _ConfirmPasswordR_textcontroller = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasCapitalLetter = false;
  bool _hasSpecialCharacter = false;
  bool _passwordMatch = false;

  String R_userFirstname = '';
  String R_userLastname = '';
  String R_userMail = '';
  String R_userPassword = '';
  String R_userConfirmPassword = '';

  onPasswordChanged(String password, String passwordconfirmation) {
    final numericRegex = RegExp(r'[0-9]');
    final CapitalCharacter = RegExp(r'[A-Z]');
    final SpecialCharacter = RegExp(r'[@_!#$%^&*()<>?/\|}{~:;]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 10) {
        _isPasswordEightCharacters = true;
      }
      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasPasswordOneNumber = true;
      }
      _hasCapitalLetter = false;
      if (CapitalCharacter.hasMatch(password)) {
        _hasCapitalLetter = true;
      }
      _hasSpecialCharacter = false;
      if (SpecialCharacter.hasMatch(password)) {
        _hasSpecialCharacter = true;
      }
      _passwordMatch = false;
      if (password == passwordconfirmation) {
        _passwordMatch = true;
      }
    });
  }

  void onPasswordMatch(String password, String passwordConfirmation) {
    setState(() {
      _passwordMatch = false;
      if (password == passwordConfirmation) {
        _passwordMatch = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("An error has occured"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/register'));
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.indigo, fontSize: 15),
                        )),
                  ],
                )
              ],
            ));
    return Scaffold(
        appBar: AppBar(
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
            children: [
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientText(
                  "Create a new account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [(Colors.indigoAccent), (Colors.indigo)],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _FirstNameR_textcontroller.clear();
                              },
                              icon: const Icon(Icons.clear))),
                      controller: _FirstNameR_textcontroller,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _LastNameR_textcontroller.clear();
                              },
                              icon: const Icon(Icons.clear))),
                      controller: _LastNameR_textcontroller,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: IconButton(
                              onPressed: () {
                                _EmailR_textcontroller.clear();
                              },
                              icon: const Icon(Icons.clear))),
                      controller: _EmailR_textcontroller,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      onChanged: (password) => onPasswordChanged(
                          password, _ConfirmPasswordR_textcontroller.text),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _PasswordR_textcontroller.clear();
                                  _passwordMatch = false;
                                  _isPasswordEightCharacters = false;
                                  _hasPasswordOneNumber = false;
                                  _hasCapitalLetter = false;
                                  _hasSpecialCharacter = false;
                                });
                              },
                              icon: const Icon(Icons.clear))),
                      controller: _PasswordR_textcontroller,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasCapitalLetter
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasCapitalLetter
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 15),
                        )),
                    SizedBox(width: 10),
                    Text("Contains a capital letter")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters
                                ? Colors.green
                                : Colors.transparent,
                            border: _isPasswordEightCharacters
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 15),
                        )),
                    SizedBox(width: 10),
                    Text("Contains at least 10 characters")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasPasswordOneNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 15),
                        )),
                    SizedBox(width: 10),
                    Text("Contains at least 1 number")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasSpecialCharacter
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasSpecialCharacter
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 15),
                        )),
                    SizedBox(width: 10),
                    Text("Contains a special character")
                  ],
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      onChanged: (password) => onPasswordMatch(
                          _PasswordR_textcontroller.text, password),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _ConfirmPasswordR_textcontroller.clear();
                                  _passwordMatch = false;
                                });
                              },
                              icon: const Icon(Icons.clear))),
                      controller: _ConfirmPasswordR_textcontroller,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _passwordMatch
                                ? Colors.green
                                : Colors.transparent,
                            border: _passwordMatch
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child:
                              Icon(Icons.check, color: Colors.white, size: 15),
                        )),
                    SizedBox(width: 10),
                    Text("Both passwords match")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  height: 65,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [(Colors.indigo), (Colors.indigoAccent)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(30),
                    ),
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        R_userFirstname = _FirstNameR_textcontroller.text;
                        R_userLastname = _LastNameR_textcontroller.text;
                        R_userMail = _EmailR_textcontroller.text;
                        R_userPassword = _PasswordR_textcontroller.text;
                        R_userConfirmPassword =
                            _ConfirmPasswordR_textcontroller.text;
                      });
                      if (_passwordMatch == true &&
                          _hasSpecialCharacter == true &&
                          _hasCapitalLetter == true &&
                          _hasPasswordOneNumber == true &&
                          _isPasswordEightCharacters == true) {
                        try {
                          await RegisterUser(
                              R_userMail,
                              R_userPassword,
                              R_userConfirmPassword,
                              R_userFirstname,
                              R_userLastname);
                        } catch (BackendException) {
                          print("Error occurred $BackendException");
                          return;
                        }
                      } else {
                        openDialog();
                      }
                      //Navigator.pushNamed(context, '/home');
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> RegisterUser(
      String emailUser,
      String passwordUser,
      String confirmPasswordUser,
      String firstnameUser,
      String lastnameUser) async {
    Map<String, dynamic> body = {
      "email": emailUser,
      "password": passwordUser,
      "passwordConfirmation": confirmPasswordUser,
      "role": 1,
      "firstName": firstnameUser,
      "lastName": lastnameUser,
    };
    final response = await NetworkService.sendRequest(
      requestType: RequestType.post,
      apiSlug: StaticValues.postRegisterUser,
      body: jsonEncode(body),
      useAuthToken: false,
    );
    print(response?.body);
    await NetworkHelper.validateResponse(response);

    // Contains a list of the format [User, String].
    // if (response?.statusCode == 201) {
    //   Navigator.popUntil(context,ModalRoute.withName('/login_page'));
    //
    // } else {
    // }
  }
}
