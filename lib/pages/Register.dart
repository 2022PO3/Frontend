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
  final _PhoneNumberR_textcontroller = TextEditingController();
  final _PasswordR_textcontroller = TextEditingController();
  final _ConfirmPasswordR_textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
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
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
                            _PhoneNumberR_textcontroller.clear();
                          },
                          icon: const Icon(Icons.clear)
                      )
                  ),
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
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
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
        ],
      )
    );
  }
}
