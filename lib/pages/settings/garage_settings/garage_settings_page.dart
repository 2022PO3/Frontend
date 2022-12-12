import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../api/models/garage_model.dart';
import '../../../api/models/garage_settings_model.dart';
import '../../../api/models/price_model.dart';
import '../../../utils/error_widget.dart';

class GarageSettingsPage extends StatefulWidget {
  const GarageSettingsPage({super.key, required this.garageId});

  final int garageId;

  @override
  State<GarageSettingsPage> createState() => _GarageSettingsPageState();
}

class _GarageSettingsPageState extends State<GarageSettingsPage> {
  late Future<Garage> garageFuture;
  late Future<GarageSettings> settingsFuture;
  late Future<List<Price>> pricesFuture;

  Future<void> reloadFutures() async {
    setState(() {
      garageFuture = getGarage(widget.garageId);
      settingsFuture = getGarageSettings(widget.garageId);
      pricesFuture = getGaragePrices(widget.garageId);
    });
  }

  @override
  void initState() {
    reloadFutures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Garage Settings', false, null),
      body: RefreshIndicator(
        onRefresh: reloadFutures,
        child: Builder(builder: (context) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics()
                .applyTo(const BouncingScrollPhysics()),
            children: [
              _Header(
                garageFuture: garageFuture,
              )
            ],
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.garageFuture}) : super(key: key);

  final Future<Garage> garageFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Garage>(
      future: garageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Garage garage = snapshot.data as Garage;
          return _buildData(context, garage);
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SnapshotErrorWidget(
              snapshot: snapshot,
            ),
          );
        }
        return const SizedBox.square(
          dimension: 0,
        );
      },
    );
  }

  Widget _buildData(BuildContext context, Garage garage) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            garage.name,
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: shortestSide / 12),
          ),
          IconButton(
            onPressed: () => showEditorDialog(context,
                fieldName: 'Garage Name',
                currentValue: garage.name, onConfirm: (garageName) {
              updateGarage(garage.copyWith(name: garageName));
            }),
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}

void showEditorDialog(BuildContext context,
    {required String fieldName,
    required String currentValue,
    Function(String)? onConfirm}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController controller =
          TextEditingController(text: currentValue);
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Edit $fieldName',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                    ),
                  ),
                  IconButton(
                      onPressed: () => context.pop(), icon: Icon(Icons.close))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const StadiumBorder(),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade900)),
                      onPressed: context.pop,
                      child: const Text('Cancel')),
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(StadiumBorder())),
                      onPressed: () {
                        onConfirm?.call(controller.text);
                        context.pop;
                      },
                      child: const Text('Confirm')),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
