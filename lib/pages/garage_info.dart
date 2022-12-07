import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/widgets/garage_opening_hours_widget.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/widgets/price_widget.dart';
import 'package:po_frontend/api/models/garage_settings_model.dart';
import 'package:po_frontend/api/models/enums.dart';

class GarageInfo extends StatefulWidget {
  const GarageInfo({Key? key}) : super(key: key);

  @override
  State<GarageInfo> createState() => _GarageInfoState();
}

class _GarageInfoState extends State<GarageInfo> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    print(arguments['garageIDargument'].id);
    final Garage garage = arguments['garageIDargument'];

    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.getUser.firstName ?? ''),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [(Colors.indigo), (Colors.indigoAccent)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: GradientText(
                    'Garage Name: ',
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
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: const [(Colors.indigoAccent), (Colors.indigo)],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: FutureBuilder(
                            future: getGarageSettings(garage.id.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final GarageSettings? garageSettings =
                                    snapshot.data;
                                return SizedBox(
                                  height: 70,
                                  width: 300,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            'Maximum amount of handicapped lots: ${garageSettings!.maxHandicappedLots}'),
                                        Text(
                                            'Maximum height: ${garageSettings.maxHeight} m'),
                                        Text(
                                            'Maximum width: ${garageSettings.maxWidth} m'),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('error');
                              }
                              return Container(
                                height: 70,
                                width: 300,
                                alignment: Alignment.center,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('Press for details'))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: SizedBox(
                height: 40,
                child: FutureBuilder(
                  future: getGarageSettings(garage.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final GarageSettings? garageSettings = snapshot.data;
                      return Text(
                        '${garageSettings!.location.country}, ${Province.getProvinceName(garageSettings.location.province)}, ${garageSettings.location.street} ${garageSettings.location.number}, ${garageSettings.location.postCode} ${garageSettings.location.municipality}',
                        style: const TextStyle(
                          color: Colors.indigo,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('error');
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
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
            ),
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
                    colors: const [(Colors.indigoAccent), (Colors.indigo)],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: SizedBox(
                height: 70,
                child: FutureBuilder(
                  future: getGaragePrice(garage.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final List<Price>? garagePrice = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return CurrentPrice(
                            price: garagePrice?[index],
                          );
                        },
                        itemCount: garagePrice?.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Text('error');
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
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
                    colors: const [(Colors.indigoAccent), (Colors.indigo)],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: SizedBox(
                height: 190,
                child: FutureBuilder(
                  future: getGarageOpening(garage.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final List<OpeningHour>? openingsHours = snapshot.data;
                      print(openingsHours);
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return GarageOpeningHoursWidget(
                            openingsHours: openingsHours?[index],
                          );
                        },
                        itemCount: openingsHours?.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Text('error');
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 65,
                padding: const EdgeInsets.all(20),
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
                    onPressed: () async {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<OpeningHour>> getGarageOpening(String garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: 'api/opening-hours/$garageId',
    useAuthToken: true,
  );
  print('api/opening-hours/$garageId');
  return await NetworkHelper.filterResponse(
      callBack: OpeningHourListFromJson, response: response);
}

Future<List<Price>> getGaragePrice(String garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: 'api/prices/$garageId',
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
      callBack: PriceListFromJson, response: response);
}

Future<GarageSettings> getGarageSettings(String garageId) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: 'api/garage-settings/$garageId',
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
      callBack: GarageSettings.fromJSON, response: response);
}
