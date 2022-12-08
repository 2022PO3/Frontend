import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
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
            appBar: AppBar(
              title: Text(garageData.garage.name),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [(Colors.indigo), (Colors.indigoAccent)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: width - 50,
                            maxHeight: 200,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
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
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: GradientText(
                            'Garage Name: ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: const [
                              (Colors.indigoAccent),
                              (Colors.indigo)
                            ],
                          ),
                        ),
                        Text(
                          garage.name,
                          style: const TextStyle(color: Colors.indigo),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: GradientText(
                            'Location: ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: const [
                              (Colors.indigoAccent),
                              (Colors.indigo)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        height: 65,
                        child: Text(
                          '${garageSettings.location.country}, ${Province.getProvinceName(garageSettings.location.province)}, ${garageSettings.location.street} ${garageSettings.location.number}, ${garageSettings.location.postCode} ${garageSettings.location.municipality}',
                          style: const TextStyle(
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),

                    /*Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: GradientText(
                    'Empty spots left: ',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: const [(Colors.indigoAccent), (Colors.indigo)],
                  ),
                ),
                Text(
                  '${garage.unoccupiedLots}/${garage.parkingLots}',
                  style: const TextStyle(color: Colors.indigo),
                )
              ],
            ),*/
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: GradientText(
                            'Garage Price: ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: const [
                              (Colors.indigoAccent),
                              (Colors.indigo)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: SizedBox(
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
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: GradientText(
                            'Opening hours: ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: const [
                              (Colors.indigoAccent),
                              (Colors.indigo)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: SizedBox(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                              '/home/reserve',
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
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [(Colors.indigo), (Colors.indigoAccent)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
              ),
            ],
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
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

Future<GarageData> getGarageData(int garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: StaticValues.getGarageSlug,
    useAuthToken: true,
    pk: garageId,
  );

  Garage garage = await NetworkHelper.filterResponse(
    callBack: Garage.fromJSON,
    response: response,
  );

  List<OpeningHour> openingHours = await getGarageOpeningHours(garageId);
  List<Price> prices = await getGaragePrices(garageId);
  GarageSettings garageSettings = await getGarageSettings(garageId);

  return GarageData(
    garage: garage,
    openingHours: openingHours,
    prices: prices,
    garageSettings: garageSettings,
  );
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
