import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';
import 'package:po_frontend/api/widgets/dayoftheweek_Widget.dart';
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
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print(arguments['garageIDargument'].id);
    final Garage garage = arguments['garageIDargument'];

    final UserProvider userProvider = Provider.of<UserProvider>(context);
    const Map<int, String> week_days = {} ;

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.getUser.firstName ?? ''),
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
                Text('${garage.name}')
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
    if (snapshot.connectionState == ConnectionState.done &&
    snapshot.hasData) {
    final GarageSettings? garagesetting = snapshot.data;
    return SizedBox(
      height: 70,
      width: 300,
      child: Center(
        child: Column(
        children: [
        Text("Maximum amount of handicapped lots: " + garagesetting!.maxHandicappedLots.toString()),
        Text("Maximum height: " + garagesetting!.maxHeight.toString()),
        Text("Maximum width: " + garagesetting!.maxWidth.toString()),
        ],
        ),
      ),
    );
    } else if (snapshot.hasError) {
    return Text("error");
    }
    return  Container( height: 70,
    width: 300,
    child: Center(child: CircularProgressIndicator()),
    alignment: Alignment.center,
    );
    },
    ),
    ));
                    },
                    child: Text(
                    "Press for details"
                    )
                )
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
                      final GarageSettings? garagesettings = snapshot.data;
                      return Text(garagesettings!.location.country + ", " + Province.getProvinceName(garagesettings!.location.province) + ", " + garagesettings!.location.street + " " + garagesettings!.location.number.toString() + ", " + garagesettings!.location.postCode.toString() + " " + garagesettings!.location.municipality + " ");
                    } else if (snapshot.hasError) {
                      return Text("error");
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.topLeft,
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
                Text('${garage.unoccupiedLots}/${garage.parkingLots}')
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
                      final List<Price>? garageprice = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return CurrentPrice(curprice: garageprice?[index],);
                        },
                        itemCount: garageprice?.length,
                      );
                    } else if (snapshot.hasError) {
                      return Text("error");
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.topLeft,
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
                      final List<OpeningHour>? openingshours = snapshot.data;
                      print(openingshours);
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Dayoftheweek(openingshours: openingshours?[index],);
                        },
                        itemCount: openingshours?.length,
                      );
                    } else if (snapshot.hasError) {
                      return Text("error");
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Container(
                          child: CircularProgressIndicator(),
                        alignment: Alignment.topLeft,
                      ),
                    );
                  },
                ),
              ),
            ),
            // FutureBuilder(
            //   future: getGaragePriceData(),
            //     builder: (context,snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done &&
            //       snapshot.hasData) {
            //         return Row(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 20),
            //               child: GradientText(
            //                 "Price: ",
            //                 textAlign: TextAlign.left,
            //                 style: TextStyle(
            //                   //fontWeight: FontWeight.bold,
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //                 colors: [(Colors.indigoAccent), (Colors.indigo)],
            //               ),
            //             ),
            //             Text("price...")
            //           ],
            //         );
            //       } else if (snapshot.hasError) {
            //         return Text("Error...");
            //       }
            //       return const Center(
            //           child: CircularProgressIndicator(),
            //       );
            //     }
            // ),
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

Future<List<OpeningHour>> getGarageOpening(String garage_ID) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: "api/opening-hours/${garage_ID}",
    useAuthToken: true,
  );
  print("api/opening-hours/${garage_ID}");
  return await NetworkHelper.filterResponse(
      callBack: OpeningHourListFromJson,
      response: response
  );
}

Future<List<Price>> getGaragePrice(String garage_ID) async {
  final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug: "api/prices/${garage_ID}",
      useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
      callBack: PriceListFromJson,
      response: response
  );
}

Future<GarageSettings> getGarageSettings(String garage_ID) async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    apiSlug: "api/garage-settings/${garage_ID}",
    useAuthToken: true,
  );
  return await NetworkHelper.filterResponse(
      callBack: GarageSettings.fromJSON,
      response: response
  );
}