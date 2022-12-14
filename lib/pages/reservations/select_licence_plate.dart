import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/api/requests/licence_plate_requests.dart';
import 'package:po_frontend/api/widgets/licence_plate_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/card.dart';

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
      appBar: appBar(
        title: 'Select licence plate',
        refreshButton: true,
        refreshFunction: () => setState(
          () => {},
        ),
      ),
      body: FutureBuilder(
        future: getLicencePlates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<LicencePlate> licencePlates =
                snapshot.data as List<LicencePlate>;
            List<LicencePlate> enabledLicencePlates = licencePlates
                .where(
                  (lp) => lp.enabled,
                )
                .toList();
            return Column(
              children: [
                buildCard(
                  'Choose the licence plate for which you want to make a reservation.',
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                if (enabledLicencePlates.isNotEmpty)
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ReservationLicencePlateWidget(
                        licencePlate: enabledLicencePlates[index],
                        garage: widget.garage,
                      );
                    },
                    itemCount: enabledLicencePlates.length,
                  ),
                if (enabledLicencePlates.isEmpty)
                  buildCard(
                    'We could not find enabled licence plates for your account. If you have already registered a licence plate, enabled them in the profile page.',
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
