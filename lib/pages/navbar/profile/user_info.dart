import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../api/network/network_exception.dart';
import 'package:po_frontend/api/models/user_model.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final newFirstNameTextController = TextEditingController();
  final newLastNameTextController = TextEditingController();
  final newEmailTextController = TextEditingController();
  final currentPasswordTextController = TextEditingController();
  final newPasswordTextController = TextEditingController();
  final checkPasswordTextController = TextEditingController();

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

  ProvinceEnum? province;
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
    void openLocationDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                  getUserFirstName(context),
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'what do you want to change your province to?',
                ),
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
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                      selectedValue = 'Select your province here';
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        province = Province.toProvinceEnum(selectedValue);
                      });
                      try {
                        User oldUser = getUser(context);
                        oldUser.location = province;
                        User newUser = await updateUser(oldUser);
                        if (mounted) setUser(context, newUser);
                        if (mounted) context.pop();
                      } on BackendException catch (e) {
                        print('Error occurred $e');
                        showFailureDialog(context, e);
                      }
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
          ),
        );

    void openDeleteUserDialog() => showDialog(
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
                    getUserFirstName(context),
                    style: const TextStyle(
                      color: Colors.indigoAccent,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'You are about to delete your account!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Are you sure you want to continue?'),
                  SizedBox(height: 10),
                  Text('Please note that this is a permanent action.'),
                  Text('You cannot restore this account after deleting it.'),
                  Text('If you want an account later on,'),
                  Text('you can always register a new one.'),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                        newLastNameTextController.clear();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.indigo, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        deleteUser();
                        context.go('/login');
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

    void openPasswordDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                  getUserFirstName(context),
                  style: const TextStyle(
                    color: Colors.indigoAccent,
                  ),
                ),
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text(
                'Your are about to change your password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your current password in the box below.',
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current password',
                  hintStyle: const TextStyle(fontSize: 15),
                  suffixIcon: IconButton(
                    onPressed: () {
                      currentPasswordTextController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
                controller: currentPasswordTextController,
              ),
              const SizedBox(height: 25),
              const Text('Enter your new password in both boxes below.'),
              TextField(
                onChanged: (password) => onPasswordChanged(
                    password, checkPasswordTextController.text),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New password',
                  hintStyle: const TextStyle(fontSize: 15),
                  suffixIcon: IconButton(
                    onPressed: () {
                      newPasswordTextController.clear();
                      _passwordMatch = false;
                      _isPasswordEightCharacters = false;
                      _hasPasswordOneNumber = false;
                      _hasCapitalLetter = false;
                      _hasSpecialCharacter = false;
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
                controller: newPasswordTextController,
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
                      color:
                          _hasCapitalLetter ? Colors.green : Colors.transparent,
                      border: _hasCapitalLetter
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Contains at least 10 characters',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
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
                      color: _hasPasswordOneNumber
                          ? Colors.green
                          : Colors.transparent,
                      border: _hasPasswordOneNumber
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains at least 1 number',
                    style: TextStyle(fontSize: 12),
                  )
                ],
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
                      color: _hasSpecialCharacter
                          ? Colors.green
                          : Colors.transparent,
                      border: _hasSpecialCharacter
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Contains a special character',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (password) =>
                    onPasswordMatch(newPasswordTextController.text, password),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                  hintStyle: const TextStyle(fontSize: 15),
                  suffixIcon: IconButton(
                    onPressed: () {
                      checkPasswordTextController.clear();
                      _passwordMatch = false;
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
                controller: checkPasswordTextController,
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
                        color:
                            _passwordMatch ? Colors.green : Colors.transparent,
                        border: _passwordMatch
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 12),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Both passwords match',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ]),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                        newPasswordTextController.clear();
                        currentPasswordTextController.clear();
                        checkPasswordTextController.clear();
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
                        newPassword = newPasswordTextController.text;
                        oldPassword = currentPasswordTextController.text;
                        passwordConfirmation = checkPasswordTextController.text;
                      });
                      if (_passwordMatch &&
                          _hasSpecialCharacter &&
                          _hasCapitalLetter &&
                          _hasPasswordOneNumber &&
                          _isPasswordEightCharacters) {
                        try {
                          await setUserPassword(
                            newPassword,
                            oldPassword,
                            passwordConfirmation,
                          );
                          if (mounted) {
                            showSuccessDialog(
                              context,
                              'Password successfully changed!',
                              'You have successfully changed your password. You\'ll now be redirected to the login page.',
                            );
                            await Future.delayed(
                              const Duration(seconds: 2),
                            );
                            if (mounted) context.pop();
                          }
                        } on BackendException catch (e) {
                          print('Error occurred $e');
                          showFailureDialog(context, e);
                        }
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
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
                UserField(
                  fieldName: 'User ID',
                  fieldNameValue: getUserId(context).toString(),
                ),
                UserField(
                  fieldName: 'First name',
                  fieldNameValue: getUserFirstName(
                    context,
                    dummy: 'No first name given',
                  ),
                  onButtonPressed: () => openDialog(
                      fieldName: 'first name',
                      newFieldValue: userFirstName,
                      textController: newFirstNameTextController,
                      updateFunction: setFirstName),
                ),
                UserField(
                  fieldName: 'Last name',
                  fieldNameValue: getUserLastName(
                    context,
                    dummy: 'No last name given',
                  ),
                  onButtonPressed: () => openDialog(
                      fieldName: 'last name',
                      newFieldValue: userLastName,
                      textController: newLastNameTextController,
                      updateFunction: setLastName),
                ),
                UserField(
                  fieldName: 'Email address',
                  fieldNameValue: getUserEmail(context),
                  onButtonPressed: () => openDialog(
                      fieldName: 'email',
                      newFieldValue: userEmail,
                      textController: newEmailTextController,
                      updateFunction: setEmail),
                ),
                UserField(
                  fieldName: 'Province',
                  fieldNameValue: getUserLocation(context),
                  onButtonPressed: () => openLocationDialog(),
                ),
                UserField(
                  fieldName: 'Favorite garage name',
                  fieldNameValue: 'test',
                  onButtonPressed: () => openLocationDialog(),
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
                buildButton(
                  'Change your password',
                  Colors.indigoAccent,
                  openPasswordDialog,
                ),
                const SizedBox(
                  height: 10,
                ),
                buildButton(
                  'Delete your account',
                  Colors.red,
                  openDeleteUserDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openDialog(
      {required String fieldName,
      required String newFieldValue,
      required TextEditingController textController,
      required Function updateFunction}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text(
              'Dear, ',
              style: TextStyle(color: Colors.indigoAccent),
            ),
            Text(
              getUserFirstName(context),
              style: const TextStyle(
                color: Colors.indigoAccent,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('What do you want to change your $fieldName to?'),
            TextField(
              decoration: InputDecoration(
                hintText: 'New $fieldName',
                hintStyle: const TextStyle(fontSize: 15),
                suffixIcon: IconButton(
                  onPressed: () {
                    textController.clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                  ),
                ),
              ),
              controller: textController,
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                  textController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    newFieldValue = textController.text;
                  });
                  try {
                    updateFunction(newFieldValue);
                    if (mounted) {
                      context.pop();
                    }
                    newFirstNameTextController.clear();
                  } on BackendException catch (e) {
                    print('Error occurred $e');
                    showFailureDialog(context, e);
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void tryUpdateUser(User oldUser) async {
    try {
      User newUser = await updateUser(oldUser);
      if (mounted) setUser(context, newUser);
    } on BackendException catch (e) {
      print(e);
      showFailureDialog(context, e);
    }
  }

  void setFirstName(String newFirstName) async {
    User oldUser = getUser(context);
    oldUser.firstName = newFirstName;
    tryUpdateUser(oldUser);
  }

  void setLastName(String newLastName) async {
    User oldUser = getUser(context);
    oldUser.lastName = newLastName;
    tryUpdateUser(oldUser);
  }

  void setEmail(String newEmail) async {
    User oldUser = getUser(context);
    oldUser.email = newEmail;
    tryUpdateUser(oldUser);
  }

  void setLocation(ProvinceEnum? location) async {
    User oldUser = getUser(context);
    oldUser.location = location;
    tryUpdateUser(oldUser);
  }

  void setFavGarageId(int? favGarageId) async {
    User oldUser = getUser(context);
    oldUser.favGarageId = favGarageId;
    tryUpdateUser(oldUser);
  }
}

class UserField extends StatelessWidget {
  const UserField({
    super.key,
    required this.fieldName,
    required this.fieldNameValue,
    this.onButtonPressed,
  });

  final String fieldName;
  final String fieldNameValue;
  final Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        child: Row(
          children: [
            Text(
              '$fieldName:',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: Text(
                fieldNameValue,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                softWrap: true,
              ),
            ),
            if (onButtonPressed != null)
              TextButton(
                onPressed: onButtonPressed,
                child: const Text('Change'),
              ),
          ],
        ),
      ),
    );
  }
}
