import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../api/network/network_exception.dart';
import 'package:po_frontend/api/models/user_model.dart';

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
      appBar: AppBar(title: const Text('Change your password')),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Column(
                children: [
                  const Text(
                    'Please select your province in the list below.'
                  ),
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
                ]
              )
            )
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
                    onPressed: () async {
                      setState(() {
                        province = ProvinceEnum.fromName(selectedValue);
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text(
                        'Confirm',
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
        ]
      )
    );
  }
}