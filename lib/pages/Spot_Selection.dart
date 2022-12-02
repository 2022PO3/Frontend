import 'package:flutter/material.dart';
import 'package:po_frontend/api/garages_page.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:po_frontend/api/models/parking_lots_model.dart';
import 'package:po_frontend/api/widgets/parking_lots_widget.dart';
import 'package:po_frontend/api/models/garage_model.dart';

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
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Garage garage = arguments['selected_garage'];
    final DateTime _date = arguments['selected_startdate'];
    final DateTime _date2 = arguments['selected_enddate'];
    print(_date.toString());
    print(_date2.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Spot Selection'),
        ),
        body: FutureBuilder(
            future: getData(garage.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final List<ParkingLots> parking_lots =
                    snapshot.data as List<ParkingLots>;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    //return ParkingLotsWidget(parking_lot: parking_lots[index]);
                    return GestureDetector(
                        child:
                            ParkingLotsWidget(parking_lot: parking_lots[index]),
                        onTap: () {
                          Navigator.pushNamed(context, '/Confirm_Reservation',
                              arguments: {
                                'selected_garage': garage,
                                'selected_startdate': _date,
                                'selected_enddate': _date2,
                                'selected_spot': parking_lots[index],
                              });
                        });
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

Future<List<ParkingLots>> getData(String garageID) async {
  print("Executing function");
  final response = await NetworkService.sendRequest(
      requestType: RequestType.get,
      apiSlug: StaticValues.getParkingLotsSlug + "/${garageID}",
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
