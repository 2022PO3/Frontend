import 'package:flutter/material.dart';

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
  final _PhoneNumberR_textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _PhoneNumberR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _PhoneNumberR_textcontroller,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
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
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _PasswordR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _PasswordR_textcontroller,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white, width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(fontSize: 20),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _ConfirmPasswordR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear))),
                    controller: _ConfirmPasswordR_textcontroller,
                  ),
                ),
              ),
            ),
/*TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(500, 50),
                  backgroundColor: Colors.indigoAccent),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
            ),*/
          ],
        ));
  }
}
