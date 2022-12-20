// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/user_model.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../../api/network/network_exception.dart';

class ChangeProvincePage extends StatefulWidget {
  const ChangeProvincePage({super.key});

  @override
  State<ChangeProvincePage> createState() => _ChangeProvincePageState();
}

class _ChangeProvincePageState extends State<ChangeProvincePage> {
  String selectedValue = 'Select your province here';

  ProvinceEnum? province;
  String? location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Change your province'),
      body: Column(
        children: [
          Card(
            shape: Constants.cardBorder,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                children: [
                  const Text('Please select your province in the list below.'),
                  DropdownButton<String>(
                    isExpanded: true,
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
            ),
          ),
          buildButton(
            'Confirm',
            Colors.indigoAccent,
            () => handleChangeProvince(),
            withCardPadding: true,
          ),
        ],
      ),
    );
  }

  void handleChangeProvince() async {
    setState(() {
      province = ProvinceEnum.fromName(selectedValue);
    });
    try {
      User oldUser = getProviderUser(context);
      oldUser.location = province;
      User newUser = await putUser(context, oldUser);
      if (mounted) setUser(context, newUser);
      if (mounted) context.pop();
    } on BackendException catch (e) {
      print('Error occurred $e');
      showFailureDialog(context, e);
    }
    selectedValue = 'Select your province here';
  }
}
