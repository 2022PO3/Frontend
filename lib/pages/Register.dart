import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [(Colors.indigo),(Colors.indigoAccent)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
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
                  border: Border.all(color: Colors.white,width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
                        hintStyle: TextStyle(
                            fontSize: 20
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _FirstNameR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear)
                        )
                    ),
                    controller: _FirstNameR_textcontroller,
                  ),
                ),
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
                  border: Border.all(color: Colors.white,width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last Name',
                        hintStyle: TextStyle(
                            fontSize: 20
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _LastNameR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear)
                        )
                    ),
                    controller: _LastNameR_textcontroller,
                  ),
                ),
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
                  border: Border.all(color: Colors.white,width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontSize: 20
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _EmailR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear)
                        )
                    ),
                    controller: _EmailR_textcontroller,
                  ),
                ),
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
                  border: Border.all(color: Colors.white,width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            fontSize: 20
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _PasswordR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear)
                        )
                    ),
                    controller: _PasswordR_textcontroller,
                  ),
                ),
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
                  border: Border.all(color: Colors.white,width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                            fontSize: 20
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _ConfirmPasswordR_textcontroller.clear();
                            },
                            icon: const Icon(Icons.clear)
                        )
                    ),
                    controller: _ConfirmPasswordR_textcontroller,
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
                    minimumSize: const Size.fromHeight(30),),
                  child: Text(
                    "Register Now",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    },
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}
