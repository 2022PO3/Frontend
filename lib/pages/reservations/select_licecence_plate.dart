import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/api/widgets/licence_plate_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';

class SelectLicencePlatePage extends StatefulWidget {
  const SelectLicencePlatePage({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;

  @override
  State<SelectLicencePlatePage> createState() => _SelectLicencePlatePageState();
}

class _SelectLicencePlatePageState extends State<SelectLicencePlatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select licence plate'),
      ),
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
                    return LicencePlateWidget(
                      licencePlate: licencePlates[index],
                      garage: widget.garage,
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
    );
  }
}
