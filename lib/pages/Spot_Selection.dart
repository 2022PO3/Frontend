import 'package:flutter/material.dart';
import 'package:po_frontend/api/garages_page.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/parking_lots_model.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';

class Spot_Selection extends StatefulWidget {
  const Spot_Selection({Key? key}) : super(key: key);

  @override
  State<Spot_Selection> createState() => _Spot_SelectionState();
}

class _Spot_SelectionState extends State<Spot_Selection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Spot Selection'),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final List<ParkingLots> parking_lots =
                    snapshot.data as List<ParkingLots>;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ParkingLotsWidget(parking_lot: parking_lots[index]);
                  },
                  itemCount: parking_lots.length,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

Future<List<ParkingLots>> getData() async {
  print("Executing function");
  final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug: StaticValues.getParkingLotsSlug,
      useAuthToken: true
      //    body: body
      );

  print("reponse $response");
  print('Response ${response?.body}');
  print('Response status code ${response?.statusCode}');

  return await NetworkHelper.filterResponse(
    callBack: parking_lotsListFromJson,
    response: response,
  );
}
