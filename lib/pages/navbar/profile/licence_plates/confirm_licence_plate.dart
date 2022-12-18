// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/button.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/dialogs.dart';

enum ButtonState { init, loading, done, error }

class ConfirmLicencePlatePage extends StatefulWidget {
  const ConfirmLicencePlatePage({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final LicencePlate licencePlate;

  @override
  State<ConfirmLicencePlatePage> createState() =>
      _ConfirmLicencePlatePageState();
}

class _ConfirmLicencePlatePageState extends State<ConfirmLicencePlatePage> {
  ButtonState state = ButtonState.init;
  bool isLoading = false;

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;

  bool _isLoading = false;
  bool _userAborted = false;
  final FileType _pickingType = FileType.custom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Enable licence plate'),
      body: Column(
        children: [
          buildCard(
            children: [
              Text(
                'Confirm the licence plate ${widget.licencePlate.formatLicencePlate()} by uploading the registration by clicking the button below.',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          showSelectedFiles(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_file_outlined),
        onPressed: () => _pickFiles(),
      ),
    );
  }

  Widget showSelectedFiles() {
    return Builder(
      builder: (BuildContext context) => _isLoading
          ? const Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: CircularProgressIndicator(),
            )
          : _userAborted
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'User has aborted the dialog',
                  ),
                )
              : _paths != null
                  ? Container(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: Scrollbar(
                        child: ListView.separated(
                          itemCount: _paths != null && _paths!.isNotEmpty
                              ? _paths!.length
                              : 1,
                          itemBuilder: (BuildContext context, int index) {
                            final String name =
                                'File ${index + 1}: ${_fileName ?? '...'}';
                            final path = kIsWeb
                                ? null
                                : _paths!
                                    .map((e) => e.path)
                                    .toList()[index]
                                    .toString();

                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    name,
                                  ),
                                  subtitle: Text(path ?? ''),
                                ),
                                const Divider(
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                buildButton(
                                  'Upload certificate',
                                  Colors.indigoAccent,
                                  showConfirmUploadPopUp,
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    )
                  : _saveAsFileName != null
                      ? ListTile(
                          title: const Text('Save file'),
                          subtitle: Text(_saveAsFileName!),
                        )
                      : const SizedBox(),
    );
  }

  void _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['jpg', 'pdf'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void showConfirmUploadPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload file?'),
          content: const Text(
            'You are about to upload your registration certificate. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                context.pop();
                await uploadCertificateFile();
                if (mounted) {
                  showSuccessDialog(
                    context,
                    'File uploaded successfully',
                    'Your certificate is uploaded successfully. You\'ll receive an email from us shortly.',
                  );
                }
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
