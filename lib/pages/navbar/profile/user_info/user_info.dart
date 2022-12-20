// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/settings/widgets/editing_widgets.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';
import 'package:po_frontend/utils/user_data.dart';

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
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar(
        title: 'User info',
        refreshButton: true,
        refreshFunction: () => setState(() => {}),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
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
                    updateFunction: setFirstName,
                  ),
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
                    updateFunction: setLastName,
                  ),
                ),
                UserField(
                  fieldName: 'Email address',
                  fieldNameValue: getUserEmail(context),
                  onButtonPressed: () => openDialog(
                    fieldName: 'email',
                    newFieldValue: userEmail,
                    textController: newEmailTextController,
                    updateFunction: setEmail,
                  ),
                ),
                buildCard(
                  children: [
                    Row(
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
                  ],
                ),
                UserField(
                  fieldName: 'Favourite garage name',
                  fieldNameValue: 'QPark Leuven',
                  onButtonPressed: openDeleteUserDialog,
                ),
                if (getUserStrikes(context) != 0)
                  Column(
                    children: [
                      const Divider(
                        endIndent: 10,
                        indent: 10,
                      ),
                      buildCard(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.error_rounded,
                                color: Colors.redAccent,
                              ),
                              const Width(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Strikes: ${getUserStrikes(context)}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxWidth: width - 82),
                                    child: const Text(
                                      'If you have three strikes, your account will be deactivated for one month!',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
                  () => context.push('/home/profile/change-password'),
                  withCardPadding: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                buildButton(
                  'Delete your account',
                  Colors.red,
                  openDeleteUserDialog,
                  withCardPadding: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleDeleteUser() {
    deleteUser(context);
    context.go('/login');
  }

  void openDeleteUserDialog() {
    return showFrontendDialog2(
      context,
      'Dear ${getUserFirstName(context)}',
      [
        const Text(
          'You are about to delete your account!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text('Are you sure you want to continue?'),
        const Height(10),
        const Text('Please note that this is a permanent action.'),
        const Text('You cannot restore this account after deleting it.'),
        const Text('If you want an account later on,'),
        const Text('you can always register a new one.'),
      ],
      () => handleDeleteUser(),
      leftButtonText: 'Yes',
      rightButtonText: 'No',
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
                    textController.clear();
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
      User newUser = await putUser(context, oldUser);
      if (mounted) setUser(context, newUser);
    } on BackendException catch (e) {
      print(e);
      showFailureDialog(context, e);
    }
  }

  void setFirstName(String newFirstName) async {
    User oldUser = getProviderUser(context);
    oldUser.firstName = newFirstName;
    tryUpdateUser(oldUser);
  }

  void setLastName(String newLastName) async {
    User oldUser = getProviderUser(context);
    oldUser.lastName = newLastName;
    tryUpdateUser(oldUser);
  }

  void setEmail(String newEmail) async {
    User oldUser = getProviderUser(context);
    oldUser.email = newEmail;
    tryUpdateUser(oldUser);
  }

  void setLocation(ProvinceEnum? location) async {
    User oldUser = getProviderUser(context);
    oldUser.location = location;
    tryUpdateUser(oldUser);
  }

  void setFavGarageId(int? favGarageId) async {
    User oldUser = getProviderUser(context);
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
      shape: Constants.cardBorder,
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
