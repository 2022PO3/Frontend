import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/widgets/garage_widget.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/constants.dart';
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
              title: garage.name,
              refreshButton: true,
              refreshFunction: () => setState(() => {}),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildOccupancyCard(garage, width),
                  buildExpandableCard(
                    'Garage prices',
                    buildPriceWidget(prices),
                  ),
                  buildExpandableCard(
                    'Opening Hours',
                    buildOpeningHourWidget(openingHours),
                  ),
                  buildExpandableCard(
                    'Location',
                    Text(
                      '${garageSettings.location.country}, ${Province.getProvinceName(garageSettings.location.province)}, ${garageSettings.location.street} ${garageSettings.location.number}, ${garageSettings.location.postCode} ${garageSettings.location.municipality}',
                      style: const TextStyle(
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  buildIconsCard(garageData),
                  const SizedBox(
                    height: 10,
                  ),
                  buildButton(garage),
                ],
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

  Widget buildTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.indigoAccent,
      ),
    );
  }

  Widget buildOccupancyCard(Garage garage, double width) {
    final bool full = garage.unoccupiedLots == 0;
    final int ratio =
        (((garage.parkingLots - garage.unoccupiedLots) / garage.parkingLots) *
                100)
            .round();
    final Color color = determineFreePlacesColor(garage);
    return Card(
      shape: Constants.cardBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 150,
                maxWidth: width / 3,
              ),
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    startAngle: 270,
                    endAngle: 270,
                    minimum: 0,
                    maximum: garage.parkingLots.toDouble(),
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.15,
                      cornerStyle: CornerStyle.bothFlat,
                      color: Colors.grey,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: garage.unoccupiedLots == garage.parkingLots
                            ? 1
                            : (garage.parkingLots - garage.unoccupiedLots)
                                .toDouble(),
                        width: 0.15,
                        sizeUnit: GaugeSizeUnit.factor,
                        cornerStyle:
                            full ? CornerStyle.bothFlat : CornerStyle.bothCurve,
                        color: color,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        angle: 90,
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$ratio %',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'full',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Visitors',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  (garage.parkingLots - garage.unoccupiedLots).toString(),
                  style: TextStyle(
                    fontSize: 45,
                    color: color,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Free spots',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  garage.unoccupiedLots.toString(),
                  style: const TextStyle(
                    fontSize: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpandableCard(String title, Widget expanded) {
    return Card(
      shape: Constants.cardBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: ExpandablePanel(
          header: buildTitle(title),
          collapsed: const SizedBox(),
          expanded: expanded,
          theme: const ExpandableThemeData(
            iconColor: Colors.indigoAccent,
          ),
        ),
      ),
    );
  }

  Widget buildPriceWidget(List<Price> prices) {
    List<PriceWidget> priceWidgets = prices
        .map(
          (p) => PriceWidget(price: p),
        )
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...priceWidgets],
    );
  }

  Widget buildOpeningHourWidget(List<OpeningHour> openingHours) {
    List<Widget> openingHoursWidgets = openingHours
        .map(
          (oh) => OpeningHourWidget(
            openingHours: oh,
          ),
        )
        .toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...openingHoursWidgets],
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

  Widget buildIconsCard(GarageData garageData) {
    final GarageSettings garageSettings = garageData.garage.garageSettings;
    return Card(
      shape: Constants.cardBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconWithText(
                FontAwesomeIcons.wheelchair,
                garageSettings.maxHandicappedLots.toString(),
              ),
              const SizedBox(
                width: 30,
              ),
              buildIconWithText(
                FontAwesomeIcons.chargingStation,
                garageSettings.maxHandicappedLots.toString(),
              ),
              const SizedBox(
                width: 30,
              ),
              buildIconWithText(
                FontAwesomeIcons.arrowsLeftRight,
                '${garageSettings.maxWidth.toString()} m',
              ),
              const SizedBox(
                width: 30,
              ),
              buildIconWithText(
                FontAwesomeIcons.arrowsUpDown,
                '${garageSettings.maxHeight.toString()} m',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(Garage garage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(
                  Constants.borderRadius,
                ),
              ),
              child: TextButton(
                child: const Text(
                  'Make a reservation',
                  style: TextStyle(
                    color: Colors.white,
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
        ],
      ),
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
