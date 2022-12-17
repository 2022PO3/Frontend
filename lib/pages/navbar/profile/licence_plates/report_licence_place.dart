import 'package:flutter/material.dart';

import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/auth/register.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/dialogs.dart';
import 'package:po_frontend/utils/sized_box.dart';

class ReportLicencePlatePage extends StatefulWidget {
  const ReportLicencePlatePage({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final String licencePlate;

  @override
  State<ReportLicencePlatePage> createState() => _ReportLicencePlatePageState();
}

class _ReportLicencePlatePageState extends State<ReportLicencePlatePage> {
  final _reportFormKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final licencePlateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Report licence plate'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          key: _reportFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Report a licence plate',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Height(20),
              buildInputField(emailTextController, 'Email'),
              const Height(10),
              buildInputField(
                null,
                'Licence plate',
                initialValue: widget.licencePlate,
              ),
              const Height(10),
              buildButton(
                'Report',
                Colors.indigoAccent,
                () => sendReportFile(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendReportFile() {
    showSuccessDialog(
      context,
      'Report submitted successfully',
      'Your report is submitted successfully. We\'ll contact you as soon as possible to discuss further actions.',
    );
  }
}
