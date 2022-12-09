import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/api/widgets/licence_plate_widget.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/dialogs.dart';

enum ButtonState { init, loading, done, error }

class LicencePlatesPage extends StatefulWidget {
  const LicencePlatesPage({Key? key}) : super(key: key);

  @override
  State<LicencePlatesPage> createState() => _LicencePlatesPageState();
}

class _LicencePlatesPageState extends State<LicencePlatesPage> {
  final _addLicencePlateFormKey = GlobalKey<FormState>();
  final addLicencePlateController = TextEditingController();

  ButtonState state = ButtonState.init;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Licence plates', true, setState),
      body: FutureBuilder(
        future: getLicencePlates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<LicencePlate> licencePlates =
                snapshot.data as List<LicencePlate>;

            return Column(
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      'Choose the licence plate for which you want to make a reservation.',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AddLicencePlateWidget(
                      licencePlate: licencePlates[index],
                    );
                  },
                  itemCount: licencePlates.length,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.error.toString(),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEnterLicencePlateDialog(),
      ),
    );
  }

  void _showEnterLicencePlateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your licence plate'),
          content: Form(
            key: _addLicencePlateFormKey,
            child: TextFormField(
              controller: addLicencePlateController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(14),
                prefixIcon: Icon(
                  Icons.phone_android_sharp,
                  color: Colors.indigoAccent,
                ),
                hintText: 'Licence plate...',
                hintStyle: TextStyle(color: Colors.black38),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an device name.';
                } else if (!RegExp(r'\d-[A-z]{3}-\d{3}').hasMatch(value)) {
                  return 'Enter a correct format!';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_addLicencePlateFormKey.currentState!.validate()) {
                  context.pop();
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    await addLicencePlate(
                        {'licencePlate': addLicencePlateController.text});
                    setState(() {
                      isLoading = false;
                    });
                    setState(() {});
                  } on BackendException catch (e) {
                    print(e);
                    setState(() {
                      isLoading = false;
                    });
                    showFailureDialog(context, e);
                  }
                }
              },
              child: const Text(
                'Add device',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
