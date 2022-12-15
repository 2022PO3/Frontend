import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_settings_page.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../api/network/network_exception.dart';
import 'package:po_frontend/api/models/user_model.dart';

import '../../settings/widgets/editing_widgets.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final newFirstNameTextController = TextEditingController();
  final newLastNameTextController = TextEditingController();
  final newEmailTextController = TextEditingController();

  String userFirstName = '';
  String userLastName = '';
  String userEmail = '';

  ProvinceEnum? selectedValue;

  //ProvinceEnum? province;
  String? location;

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
                ProvinceSelector(
                  initialValue: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                )
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
                      selectedValue = null;
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
                      /*setState(() {
                        province = Province.toProvinceEnum(selectedValue);
                      });*/
                      try {
                        User oldUser = getUser(context);
                        oldUser.location = selectedValue;
                        User newUser = await updateUser(oldUser);
                        if (mounted) setUser(context, newUser);
                        if (mounted) context.pop();
                      } on BackendException catch (e) {
                        print('Error occurred $e');
                        showFailureDialog(context, e);
                      }
                      selectedValue = null;
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Province:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          child: Text(
                            getUserLocation(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            softWrap: true,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/home/profile/change-province');
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                ),
                UserField(
                  fieldName: 'Favorite garage name',
                  fieldNameValue: 'test',
                  onButtonPressed: openDeleteUserDialog,
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                          ),
                          onPressed: () {
                            context.push('/home/profile/change-password');
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            child: Text(
                              'Change your password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
