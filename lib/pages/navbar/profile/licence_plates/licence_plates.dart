// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/network/network_exception.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/api/widgets/licence_plate_widget.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/item_widgets.dart';
import 'package:po_frontend/utils/sized_box.dart';

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
    return buildEditItemsScreen<LicencePlate>(
        title: 'Licence plates',
        future: getLicencePlates(),
        itemWidget: buildOverviewLicencePlateWidget,
        refreshFunction: () async {
          setState(() => {});
        },
        addButton: true,
        addFunction: showEnterLicencePlateDialog);
  }

  void showEnterLicencePlateDialog() {
    return showFrontendDialog1(
      context,
      'Enter your licence plate',
      [buildAddLicencePlateForm()],
      buttonText: 'Add licence plate',
      buttonFunction: () => addLicencePlateFromDialog(),
    );
  }

  Widget buildAddLicencePlateForm() {
    return Form(
      key: _addLicencePlateFormKey,
      child: TextFormField(
        controller: addLicencePlateController,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(14),
          prefixIcon: Icon(
            Icons.directions_car,
            color: Colors.indigoAccent,
          ),
          hintText: 'Licence plate...',
          hintStyle: TextStyle(color: Colors.black38),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your licence plate.';
          } else if (!RegExp(r'\d-[A-z]{3}-\d{3}').hasMatch(value)) {
            return 'Enter a correct format!';
          }
          return null;
        },
      ),
    );
  }

  void addLicencePlateFromDialog() async {
    final String licencePlate = formatLicencePlate(
      addLicencePlateController.text,
    );
    if (_addLicencePlateFormKey.currentState!.validate()) {
      context.pop();
      setState(() {
        isLoading = true;
      });
      try {
        await postLicencePlate({'licencePlate': licencePlate});
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          showSuccessDialog(
            context,
            'Added licence plate',
            'Your licence plate is added to your account. Please note that you cannot use this licence plate until it is verified. Click the licence plate for more information.',
          );
        }
        setState(() {});
      } on BackendException catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        if (e.toString().contains('already exists')) {
          showReportDialog(licencePlate);
        } else {
          showFailureDialog(context, e);
        }
      }
    }
  }

  String formatLicencePlate(String lp) {
    return lp.replaceAll('-', '').toUpperCase();
  }

  void showReportDialog(String licencePlate) {
    return showFrontendDialog2(
      context,
      'Licence plate already exists',
      [
        const Text(
          'This licence plate is already found in our system, but not yet activated. Do you think someone else registered your licence plate? Report it to us, such that we can investigate the case.',
        ),
        const Height(5),
        const Text(
          'Please note that a vehicle registration certificate is needed for us to verify the ownership of the licence plate.',
        ),
      ],
      () => handleReportLicencePlate(licencePlate),
      leftButtonText: 'Report',
    );
  }

  void handleReportLicencePlate(String licencePlate) {
    context.pop();
    context.push(
      '/home/profile/licence-plates/report',
      extra: licencePlate,
    );
  }
}
