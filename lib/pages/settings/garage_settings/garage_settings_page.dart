import 'package:flutter/material.dart';

import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/requests/price_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/settings/garage_settings/prices_editor.dart';
import 'package:po_frontend/utils/card.dart';
import '../../../api/models/enums.dart';
import '../../../api/models/garage_model.dart';
import '../../../api/models/price_model.dart';
import '../../../utils/error_widget.dart';
import '../widgets/editing_widgets.dart';
import 'garage_editor.dart';

class GarageSettingsPage extends StatefulWidget {
  const GarageSettingsPage({super.key, required this.garageId});

  final int garageId;

  @override
  State<GarageSettingsPage> createState() => _GarageSettingsPageState();
}

class _GarageSettingsPageState extends State<GarageSettingsPage> {
  late Future<Garage> garageFuture;
  late Future<List<Price>> pricesFuture;

  Future<Future<List<Object>>> reloadFutures() async {
    setState(() {
      garageFuture = getGarage(widget.garageId);
      pricesFuture = getPrices(widget.garageId);
    });
    return Future.wait([garageFuture, pricesFuture]);
  }

  Future<void> setGarage(Garage garage) async {
    garageFuture = putGarage(garage);
    await garageFuture;
    setState(() {});
  }

  @override
  void initState() {
    reloadFutures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Garage Settings', refreshButton: false),
      body: RefreshIndicator(
        onRefresh: reloadFutures,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics().applyTo(
            const BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              _Header(
                garageFuture: garageFuture,
                onChanged: (garage) => setGarage(garage),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: FutureBuilder<Garage>(
                  future: garageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      Garage garage = snapshot.data as Garage;
                      return GarageEditor(
                          original: garage, onChanged: setGarage);
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SnapshotErrorWidget(
                          snapshot: snapshot,
                        ),
                      );
                    }
                    return const Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                child: FutureBuilder<List<Price>>(
                  future: pricesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List<Price> prices = snapshot.data as List<Price>;
                      prices.sort((a, b) => b.duration.compareTo(a.duration));
                      return PricesEditor(
                        prices: prices,
                        onPriceChanged: (price) async {
                          if (prices.map((e) => e.id).contains(price.id)) {
                            print('Updating price');
                            await putPrice(price);
                          } else {
                            print('Creating price');
                            await postPrice(
                                price.copyWith(garageId: widget.garageId),
                                widget.garageId);
                          }
                          setState(() {
                            pricesFuture = getPrices(widget.garageId);
                          });
                        },
                        onDelete: (price) async {
                          await deletePrice(price);
                          setState(() {
                            pricesFuture = getPrices(widget.garageId);
                          });
                        },
                        onValutaChanged: (ValutaEnum valuta) async {
                          List<Future> futures = [];
                          for (var price in prices) {
                            futures
                                .add(putPrice(price.copyWith(valuta: valuta)));
                          }
                          await Future.wait(futures);
                          setState(() {
                            pricesFuture = getPrices(widget.garageId);
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SnapshotErrorWidget(
                          snapshot: snapshot,
                        ),
                      );
                    }
                    return const Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.garageFuture,
    this.onChanged,
  }) : super(key: key);

  final Future<Garage> garageFuture;
  final Function(Garage garage)? onChanged;

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
        return const Center(
          child: SizedBox(),
        );
      },
    );
  }

  Widget _buildData(BuildContext context, Garage garage) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditableField(
            fieldName: 'Garage Name',
            currentValue: garage.name,
            showFieldName: false,
            valueTextStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: shortestSide / 12,
            ),
            onEdit: (garageName) async {
              Garage updatedGarage = await putGarage(
                garage.copyWith(
                  name: garageName,
                ),
              );
              onChanged?.call(updatedGarage);
            },
          ),
          Text(
            '${garage.parkingLots - garage.unoccupiedLots} / ${garage.parkingLots}'
                .toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: shortestSide / 16,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.child, this.title})
      : super(key: key);

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return buildCard(
      children: [
        if (title != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title!,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.shortestSide / 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        if (title != null) const Divider(),
        child,
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
