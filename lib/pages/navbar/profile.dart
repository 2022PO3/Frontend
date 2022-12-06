import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/enums.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import '../../api/network/network_exception.dart';
import 'package:po_frontend/api/models/user_model.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final newFirstNametextcontroller = TextEditingController();
  final newLastNametextcontroller = TextEditingController();
  final newEmailtextcontroller = TextEditingController();
  final currentPasswordtextcontroller = TextEditingController();
  final newPasswordtextcontroller = TextEditingController();
  final checkPasswordtextcontroller = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasCapitalLetter = false;
  bool _hasSpecialCharacter = false;
  bool _passwordMatch = false;

  String userFirstName = '';
  String userLastName = '';
  String userEmail = '';
  String newPassword = '';
  String oldPassword = '';
  String passwordConfirmation = '';

  String selectedValue = 'Select your province here';

  String? province;
  String? location;

  onPasswordChanged(String password, String passwordConfirmation) {
    final numericRegex = RegExp(r'[0-9]');
    final capitalCharacterRegex = RegExp(r'[A-Z]');
    final specialCharacterRegex = RegExp(r'[@_!#$%^&*()<>?/\|}{~:;]');

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
      if (capitalCharacterRegex.hasMatch(password)) {
        _hasCapitalLetter = true;
      }
      _hasSpecialCharacter = false;
      if (specialCharacterRegex.hasMatch(password)) {
        _hasSpecialCharacter = true;
      }
      _passwordMatch = false;
      if (password == passwordConfirmation &&
          password != '' &&
          passwordConfirmation != '') {
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
    final UserProvider UserinfoPr = Provider.of<UserProvider>(context);
    Future openFirstnameDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your first name to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New first name',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            newFirstNametextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: newFirstNametextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      newFirstNametextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userFirstName = newFirstNametextcontroller.text;
                    });
                    try{
                      await setFirstName(userFirstName);
                      if (mounted) {
                        Navigator.popUntil(
                          context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    newFirstNametextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openLastnameDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your last name to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New last name',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            newLastNametextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: newLastNametextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      newLastNametextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userLastName = newLastNametextcontroller.text;
                    });
                    try{
                      await setLastName(userLastName);
                      if (mounted) {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    newLastNametextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openEmailDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your e-mail adress to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New e-mail adress',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            newEmailtextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: newEmailtextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      newEmailtextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userEmail = newEmailtextcontroller.text;
                    });
                    try{
                      await setEmail(userEmail);
                      if (mounted) {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    newEmailtextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openLocationDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your province to?'),
                DropdownButton<String>(
                  value: selectedValue,
                    items: <String>[
                      'Select your province here',
                      'Antwerpen',
                      'Henegouwen',
                      'Limburg',
                      'Luik',
                      'Luxemburg',
                      'Namen',
                      'Oost-Vlaanderen',
                      'Vlaams-Brabant',
                      'Waals-Brabant',
                      'West-Vlaanderen',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        selectedValue = newValue!;
                      });
                    }
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      selectedValue = 'Select your province here';
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      province = abbreviateProvince(selectedValue);
                    });
                    try{
                      await setLocation(province);
                      if (mounted) {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    selectedValue = 'Select your province here';
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openDeleteUserDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'You are about to delete your account!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  )
                ),
                Text('Are you sure you want to continue?'),
                SizedBox(height: 10),
                Text('Please note that this is a permanent action.'),
                Text('You cannot restore this account after deleting it.'),
                Text('If you want an account later on,'),
                Text('you can always register a new one.')
                ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      newLastNametextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                     deleteUser();
                     Navigator.popUntil(
                       context, ModalRoute.withName('/login_page')
                     );
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openPasswordDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your are about to change your password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 20),
                const Text('Enter your current password in the box below.'),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Current password',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            currentPasswordtextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: currentPasswordtextcontroller,
                ),
                const SizedBox(height: 25),
                const Text('Enter your new password in both boxes below.'),
                TextField(
                  onChanged: (password) => onPasswordChanged(
                      password, checkPasswordtextcontroller.text),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New password',
                    hintStyle: const TextStyle(fontSize: 15),
                    suffixIcon: IconButton(
                      onPressed: (){
                        newPasswordtextcontroller.clear();
                        _passwordMatch = false;
                        _isPasswordEightCharacters = false;
                        _hasPasswordOneNumber = false;
                        _hasCapitalLetter = false;
                        _hasSpecialCharacter = false;
                      },
                      icon: const Icon(Icons.clear))),
                  controller: newPasswordtextcontroller,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _hasCapitalLetter
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasCapitalLetter
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        )),
                    const SizedBox(width: 5),
                    const Text(
                      'Contains a capital letter',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters
                                ? Colors.green
                                : Colors.transparent,
                            border: _isPasswordEightCharacters
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      'Contains at least 10 characters',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasPasswordOneNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      'Contains at least 1 number',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _hasSpecialCharacter
                                ? Colors.green
                                : Colors.transparent,
                            border: _hasSpecialCharacter
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      'Contains a special character',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (password) =>
                      onPasswordMatch(newPasswordtextcontroller.text, password),
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            checkPasswordtextcontroller.clear();
                            _passwordMatch = false;
                          },
                          icon: const Icon(Icons.clear))),
                  controller: checkPasswordtextcontroller,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _passwordMatch
                                ? Colors.green
                               : Colors.transparent,
                            border: _passwordMatch
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 12),
                        )),
                    const SizedBox(width: 10),
                    const Text(
                      'Both passwords match',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      newPasswordtextcontroller.clear();
                      currentPasswordtextcontroller.clear();
                      checkPasswordtextcontroller.clear();
                      _passwordMatch = false;
                      _isPasswordEightCharacters = false;
                      _hasPasswordOneNumber = false;
                      _hasCapitalLetter = false;
                      _hasSpecialCharacter = false;
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      newPassword = newPasswordtextcontroller.text;
                      oldPassword = currentPasswordtextcontroller.text;
                      passwordConfirmation = checkPasswordtextcontroller.text;
                    });
                    if (_passwordMatch &&
                        _hasSpecialCharacter &&
                        _hasCapitalLetter &&
                        _hasPasswordOneNumber &&
                        _isPasswordEightCharacters) {
                      try {
                        await setUserPassword(newPassword, oldPassword, passwordConfirmation);
                        if (mounted) {
                          _showSuccessDialog(context);
                          await Future.delayed(const Duration(seconds: 4));
                          if (mounted) {
                            Navigator.popAndPushNamed(context, '/login_page');
                          }
                        }
                      } on BackendException catch (e) {
                        print('Error occurred $e');
                      }
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    return Scaffold(
        appBar: AppBar(
            title: const Text('Profile')
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Text(
                  'User Info:',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                    children: [
                      const Text(
                          'User-ID: ',
                          style: TextStyle(
                            fontSize: 20,
                          )
                      ),
                      Text(
                          UserinfoPr.getUser.id.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                      )
                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            const Text(
                              'First name: ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                                UserinfoPr.getUser.firstName ?? 'No first name given',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ]
                      ),
                      TextButton(
                        onPressed: () {
                          openFirstnameDialog();
                        },
                        child: const Text('Change'),
                      )
                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            const Text(
                                'Last name: ',
                                style: TextStyle(
                                  fontSize: 20,
                                )
                            ),
                            Text(
                                UserinfoPr.getUser.lastName ?? 'No last name given',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            )
                          ]
                      ),
                      TextButton(
                        onPressed: (){
                          openLastnameDialog();
                        },
                        child: const Text('Change'),
                      )

                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            const Text(
                                'E-mail adress: ',
                                style: TextStyle(
                                    fontSize: 20
                                )
                            ),
                            Text(
                                UserinfoPr.getUser.email,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            )
                          ]
                      ),
                      TextButton(
                          onPressed: (){
                            openEmailDialog();
                          },
                          child: const Text('Change')
                      )
                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            const Text(
                                'Province: ',
                                style: TextStyle(
                                  fontSize: 20,
                                )
                            ),
                            if (UserinfoPr.getUser.location == null)...[
                              const Text(
                                  'Not given',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ]else...[
                              Text(
                                  Province.getProvinceName(UserinfoPr.getUser.location),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ]
                          ]
                      ),
                      TextButton(
                          onPressed: (){
                            openLocationDialog();
                          },
                          child: const Text('Change')
                      )
                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                    children: [
                      const Text(
                          'Id favorite garage: ',
                          style: TextStyle(
                            fontSize: 20,
                          )
                      ),
                      Text(
                          UserinfoPr.getUser.favGarageId.toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      )
                    ]
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: (){
                      openPasswordDialog();
                    },
                    child: const Text(
                        'Change you password',
                        style: TextStyle(
                            fontSize: 20
                        )
                    )
                ),
              ],
            ),
            Column(
            children: [
              TextButton(
                onPressed: (){
                  openDeleteUserDialog();
                },
                child: const Text(
                  'Delete your account',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20
                  )
                )
              ),
              const SizedBox(height: 20)
            ]
          )
          ]
        )
    );
  }

  Future<bool> setFirstName(String newFirstName) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.getUser.location == null){
      setState(() {
        location = null;
      });
    }else{
      setState((){
        location = abbreviateProvince(Province.getProvinceName(userProvider.getUser.location));
      });
    }
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': userProvider.getUser.email,
      'role': userProvider.getUser.role,
      'firstName': newFirstName,
      'lastName': userProvider.getUser.lastName,
      'location': location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
      requestType: RequestType.put,
      apiSlug: StaticValues.getUserSlug,
      body: body,
      useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
        callBack: User.userFromJson,
        response: response,
    );
    if (mounted){
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setLastName(String newLastName) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.getUser.location == null){
      setState(() {
        location = null;
      });
    }else{
      setState((){
        location = abbreviateProvince(Province.getProvinceName(userProvider.getUser.location));
      });
    }
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': userProvider.getUser.email,
      'role': userProvider.getUser.role,
      'firstName': userProvider.getUser.firstName,
      'lastName': newLastName,
      'location': location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.getUserSlug,
        body: body,
        useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
      callBack: User.userFromJson,
      response: response,
    );
    if (mounted){
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setEmail(String newEmail) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.getUser.location == null){
      setState(() {
        location = null;
      });
    }else{
      setState((){
        location = abbreviateProvince(Province.getProvinceName(userProvider.getUser.location));
      });
    }
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': newEmail,
      'role': userProvider.getUser.role,
      'firstName': userProvider.getUser.firstName,
      'lastName': userProvider.getUser.lastName,
      'location': location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.getUserSlug,
        body: body,
        useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
      callBack: User.userFromJson,
      response: response,
    );
    if (mounted){
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setLocation(String? newProvince) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': userProvider.getUser.email,
      'role': userProvider.getUser.role,
      'firstName': userProvider.getUser.firstName,
      'lastName': userProvider.getUser.lastName,
      'location': newProvince.toString(),
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.getUserSlug,
        body: body,
        useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
      callBack: User.userFromJson,
      response: response,
    );
    if (mounted){
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> deleteUser() async{
    final response = await NetworkService.sendRequest(
        requestType: RequestType.delete,
        apiSlug: StaticValues.getUserSlug,
        useAuthToken: true
    );
    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setUserPassword(
      String oldPassword,
      String newPassword,
      String passwordConfirmation) async{
    Map<String, dynamic> body = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'passwordConfirmation': passwordConfirmation,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.changePassword,
        body: body,
        useAuthToken: true
    );
    print(response);
    return NetworkHelper.validateResponse(response);
  }

  abbreviateProvince(String? province){
    if (province == null){
      return null;
    }
    else if (province == 'Antwerpen'){
      return 'ANT';
    }
    else if (province == 'Henegouwen'){
      return 'HAI';
    }
    else if (province == 'Luik'){
      return 'LIE';
    }
    else if (province == 'Limburg'){
      return 'LIM';
    }
    else if (province == 'Luxemburg'){
      return 'LUX';
    }
    else if (province == 'Namen'){
      return 'NAM';
    }
    else if (province == 'Oost-Vlaanderen'){
      return 'OVL';
    }
    else if (province == 'West-Vlaanderen'){
      return 'WVL';
    }
    else if (province == 'Vlaams-Brabant'){
      return 'VBR';
    }
    else if (province == 'Waals-Brabant'){
        return 'WBR';
    }
  }
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Password successfully changed!'),
        content: const Text(
            'You have successfully changed your password. You\'ll now be redirected to the login page.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
