import 'package:flutter/material.dart';
import 'package:po_frontend/UserData/UserDataBase.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
class Login_Page extends StatefulWidget {
  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  Future WrongPassword_popup() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Wrong userinfo..."),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(context,ModalRoute.withName('/login_page'));
                  },
                  child: Text("Go Back")
              ),
            ],
          )
        ],

      )
  );
  final _email_textcontroller = TextEditingController();
  final _password_textcontroller = TextEditingController();

  String userMail = '';
  String userPassword = '';

  List<UserInfo> users = List.from(UserDataBase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent.withOpacity(0.03),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () {
                  //
                },
                icon: Icon(
                  Icons.help,
                  size: 45,
                )
            ),
          )
        ],
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
              height: 10,
            ),
            //Hello again!
            GradientText(
              "Hello Again!",
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              colors: [(Colors.indigoAccent),(Colors.indigo)],
            ),
            SizedBox(
              height: 10,
            ),
            GradientText(
              "Welcome back, you\'ve been missed!",
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 30,
                  fontWeight: FontWeight.bold,
              ),
              colors: [(Colors.indigoAccent),(Colors.indigo)],
            ),
            //email textfield
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.5),width: 4),
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
                            _email_textcontroller.clear();
                          },
                          icon: const Icon(Icons.clear)
                      )
                    ),
                    controller: _email_textcontroller,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            //password textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigoAccent.withOpacity(0.5),width: 4),
                  borderRadius:  BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontSize: 20
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _password_textcontroller.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    controller: _password_textcontroller,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 65,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [(Colors.indigo),(Colors.indigoAccent)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(500, 200)
                  ),
                  child: Text(
                        "Sign in",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      
                    ),
                    ),
                  onPressed: () {
                    setState(() {
                      userMail = _email_textcontroller.text;
                      userPassword = _password_textcontroller.text;
                    });
                    bool EmailUserFound = false;
                    print(userMail);
                    int counter = 0;
                    print(users[0].userEmail);
                    for(int index = 0; index < UserDataBase.length && EmailUserFound == false; index++) {
                      if (userMail == UserDataBase[index].userEmail) {
                        print("email found");
                        if (userPassword == UserDataBase[index].userPassword) {
                          EmailUserFound = true;
                          Navigator.pushNamed(context, '/home');
                        }
                        else {
                          EmailUserFound = true;
                          WrongPassword_popup();
                        }
                      }
                    else {
                      counter = counter + 1;
                      }
                    }
                    if (counter == UserDataBase.length) {
                      WrongPassword_popup();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            //not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member? '),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
