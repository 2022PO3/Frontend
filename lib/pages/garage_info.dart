import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/widgets/garage_opening_hours_widget.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/widgets/price_widget.dart';
import 'package:po_frontend/api/models/garage_settings_model.dart';
import 'package:po_frontend/api/models/enums.dart';

class GarageInfoPage extends StatefulWidget {
  const GarageInfoPage({Key? key, required this.garageId}) : super(key: key);

  final int garageId;

  @override
  State<GarageInfoPage> createState() => _GarageInfoPageState();
}

class _GarageInfoPageState extends State<GarageInfoPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getGarageData(widget.garageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final GarageData garageData = snapshot.data as GarageData;

          Garage garage = garageData.garage;
          GarageSettings garageSettings = garageData.garageSettings;
          List<OpeningHour> openingHours = garageData.openingHours;
          List<Price> prices = garageData.prices;

          return Scaffold(
            appBar: appBar(
              title: garageData.garage.name,
              refreshButton: true,
              refreshFunction: () => setState(() => {}),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gradientText('Free spots:'),
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                              ),
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: garage.parkingLots.toDouble(),
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: const AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Colors.grey,
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: garage.unoccupiedLots.toDouble(),
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                      )
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        positionFactor: 0.1,
                                        angle: 90,
                                        widget: Text(
                                          '${garage.unoccupiedLots.toStringAsFixed(0)} / ${garage.parkingLots}',
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gradientText('Location'),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 65,
                              width: width,
                              child: Text(
                                '${garageSettings.location.country}, ${Province.getProvinceName(garageSettings.location.province)}, ${garageSettings.location.street} ${garageSettings.location.number}, ${garageSettings.location.postCode} ${garageSettings.location.municipality}',
                                style: const TextStyle(
                                  color: Colors.indigo,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gradientText('Garage prices:'),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return CurrentPrice(
                                    price: prices[index],
                                  );
                                },
                                itemCount: prices.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gradientText('Opening hours'),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 190,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GarageOpeningHoursWidget(
                                    openingsHours: openingHours[index],
                                  );
                                },
                                itemCount: openingHours.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildIconWithText(
                                FontAwesomeIcons.wheelchair,
                                garageData
                                    .garage.garageSettings.maxHandicappedLots
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              buildIconWithText(
                                FontAwesomeIcons.chargingStation,
                                garageData
                                    .garage.garageSettings.maxHandicappedLots
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              buildIconWithText(
                                FontAwesomeIcons.arrowsLeftRight,
                                '${garage.garageSettings.maxWidth.toString()} m',
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              buildIconWithText(
                                FontAwesomeIcons.arrowsUpDown,
                                '${garage.garageSettings.maxHeight.toString()} m',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        height: 65,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [(Colors.indigo), (Colors.indigoAccent)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(30),
                          ),
                          child: Text(
                            'Make a reservation',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            context.go(
                              '/home/select-licence-plate',
                              extra: garage,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
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
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: appBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget gradientText(String text) {
    return GradientText(
      text,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      colors: const [(Colors.indigoAccent), (Colors.indigo)],
    );
  }

  Widget buildIconWithText(dynamic icon, String text) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 30,
          color: Colors.black,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class GarageData {
  const GarageData({
    Key? key,
    required this.garage,
    required this.openingHours,
    required this.prices,
    required this.garageSettings,
  });

  final Garage garage;
  final List<OpeningHour> openingHours;
  final List<Price> prices;
  final GarageSettings garageSettings;
}
