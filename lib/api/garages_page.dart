import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:po_frontend/api/network/network_enums.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import 'package:po_frontend/api/network/static_values.dart';

import 'models/garage_model.dart';
import 'widgets/garage_widget.dart';

class GaragesPage extends StatefulWidget {
  const GaragesPage({Key? key}) : super(key: key);

  @override
  State<GaragesPage> createState() => _GaragesPageState();
}

class _GaragesPageState extends State<GaragesPage> {
  double width = 200, height = 200;
  @override
  Widget build(BuildContext context) {
    RendererBinding.instance.setSemanticsEnabled(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garages'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<Garage> garages = snapshot.data as List<Garage>;

            return ListView.builder(
              itemBuilder: (context, index) {
                return Semantics(
                    label: 'Article widget Title ${garages[index].name}',
                    child: GarageWidget(garage: garages[index]));
              },
              itemCount: garages.length,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Something Went Wrong')
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

Future<List<Garage>?> getData() async {
  final response = await NetworkService.sendRequest(
    requestType: RequestType.get,
    url: StaticValues.baseUrl + StaticValues.getGaragesSlug,
  );

  debugPrint('Response ${response?.body}');
  debugPrint('Response status code ${response?.statusCode}');

  return await NetworkHelper.filterResponse(
      callBack: garagesListFromJson,
      response: response,
      onFailureCallBackWithMessage: (errorType, msg) {
        debugPrint('Error type: $errorType - Message: $msg');
        throw Exception();
      });
}
