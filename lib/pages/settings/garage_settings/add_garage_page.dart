// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/garage_settings_model.dart';
import 'package:po_frontend/api/models/location_model.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/api/requests/price_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_editor.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_settings_page.dart';
import 'package:po_frontend/pages/settings/garage_settings/prices_editor.dart';
import '../../../api/models/garage_model.dart';
import '../widgets/editing_widgets.dart';

class AddGaragePage extends StatefulWidget {
  const AddGaragePage({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<AddGaragePage> createState() => _AddGaragePageState();
}

class _AddGaragePageState extends State<AddGaragePage> {
  final ScrollController mainController = ScrollController();
  late TextStyle stepTextStyle = TextStyle(
    fontSize: MediaQuery.of(context).size.shortestSide / 20,
    fontWeight: FontWeight.w600,
  );
  late Garage garage = Garage(
      id: -1,
      userId: widget.userId,
      name: 'My new Garage',
      parkingLots: [],
      entered: 0,
      reservations: 0,
      garageSettings: GarageSettings(
        id: -1,
        location: Location(
            id: -1,
            country: 'België',
            province: ProvinceEnum.ANT,
            municipality: '',
            postCode: 1000,
            street: '',
            number: 1),
        electricCars: 0,
        maxHeight: 2.3,
        maxWidth: 3,
        maxHandicappedLots: 0,
      ),
      nextFreeSpot: null);

  List<Price> prices = [];

  late TextEditingController nameEditingController = TextEditingController(
    text: garage.name,
  );

  int stepIndex = 0;

  Map<int, bool Function(Garage garage, List<Price> prices)> validators = {
    0: (garage, _) => garage.name != '',
    1: (garage, _) => garage.garageSettings.location.isValid,
    2: (garage, _) => garage.garageSettings.isValid,
    3: (_, prices) =>
        prices
            .map((a) =>
                prices.where((b) => a.duration == b.duration).length == 1)
            .every((result) => result == true) &&
        prices
            .where((e) => e.priceString.trim() == '')
            .isEmpty // Check for duplicate durations
  };

  bool canGoToStep(int index) {
    // Check if all previous pages are valid
    index -= 1;
    while (index >= 0) {
      if (!(validators[index]?.call(garage, prices) ?? true)) return false;
      index -= 1;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: appBar(title: 'Add new garage'),
      body: SafeArea(
        child: Scrollbar(
          controller: mainController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: EditableField(
                  fieldName: 'Garage Name',
                  currentValue: garage.name,
                  showFieldName: false,
                  valueTextStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: shortestSide / 12,
                  ),
                  onEdit: (garageName) async {
                    nameEditingController.text = garageName;
                    setState(
                      () {
                        garage = garage.copyWith(
                          name: garageName,
                        );
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      children: [
                        if (details.currentStep < 4)
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const StadiumBorder(),
                              ),
                            ),
                            onPressed: canGoToStep(details.currentStep + 1)
                                ? details.onStepContinue
                                : null,
                            child: const Text('Continue'),
                          ),
                        if (details.currentStep > 0 && details.currentStep < 4)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                      ],
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                  type: StepperType.vertical,
                  currentStep: stepIndex,
                  onStepCancel: () {
                    if (stepIndex > 0) {
                      setState(() {
                        stepIndex -= 1;
                      });
                    }
                  },
                  onStepContinue: () {
                    setState(() {
                      stepIndex += 1;
                    });
                  },
                  onStepTapped: (int index) {
                    while (index >= 0) {
                      // Go to tapped index or to the step preventing it.
                      if (canGoToStep(index)) {
                        setState(() {
                          stepIndex = index;
                        });
                        return;
                      }
                      index -= 1;
                    }
                  },
                  steps: <Step>[
                    Step(
                      title: Text('Enter garage name', style: stepTextStyle),
                      content: Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          controller: nameEditingController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Garage name',
                          ),
                          onChanged: (garageName) {
                            setState(() {
                              garage = garage.copyWith(name: garageName);
                            });
                          },
                        ),
                      ),
                    ),
                    Step(
                      title: Text('Set garage location', style: stepTextStyle),
                      content: LocationEditorWidget(
                        showTitle: false,
                        original: garage.garageSettings.location,
                        currentValue: garage.garageSettings.location,
                        onChanged: (location) => setState(() {
                          garage = garage.copyWith(
                            garageSettings: garage.garageSettings.copyWith(
                              location: location,
                            ),
                          );
                        }),
                        onConfirm: (location) async {},
                      ),
                    ),
                    Step(
                      title: Text(
                        'Edit Details',
                        style: stepTextStyle,
                      ),
                      content: GarageDetailsEditorWidget(
                        showTitle: false,
                        original: garage.garageSettings,
                        currentValue: garage.garageSettings,
                        onChanged: (settings) => setState(() {
                          garage = garage.copyWith(garageSettings: settings);
                        }),
                        onConfirm: (location) async {},
                      ),
                    ),
                    Step(
                      title: Text(
                        'Add prices',
                        style: stepTextStyle,
                      ),
                      content: PricesEditor(
                        prices: prices,
                        onPriceChanged: (Price price) {
                          if (price.id == -1) {
                            // Give the price a unique id
                            if (prices.isEmpty) {
                              price = price.copyWith(id: 0);
                            } else if (prices.length == 1) {
                              price = price.copyWith(id: prices.single.id + 1);
                            } else {
                              int maxId = prices
                                  .map((e) => e.id)
                                  .reduce((a, b) => max(a, b));
                              price = price.copyWith(id: maxId + 1);
                            }
                          }
                          setState(() {
                            prices.removeWhere((e) => e.id == price.id);
                            prices.add(price);
                            prices.sort(
                                (a, b) => b.duration.compareTo(a.duration));
                          });
                        },
                        onDelete: (price) {
                          setState(() {
                            prices.remove(price);
                          });
                        },
                        onValutaChanged: (valuta) {
                          setState(() {
                            prices = prices
                                .map((e) => e.copyWith(valuta: valuta))
                                .toList();
                          });
                        },
                      ),
                    ),
                    Step(
                      title: Text(
                        'Create your garage',
                        style: stepTextStyle,
                      ),
                      content: Align(
                        alignment: Alignment.centerLeft,
                        child: CreateGarageButton(
                          garage: garage,
                          prices: prices,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateGarageButton extends StatefulWidget {
  const CreateGarageButton(
      {Key? key, required this.garage, required this.prices})
      : super(key: key);

  final Garage garage;
  final List<Price> prices;
  @override
  State<CreateGarageButton> createState() => _CreateGarageButtonState();
}

class _CreateGarageButtonState extends State<CreateGarageButton> {
  Future<Garage>? garageFuture;
  Future<void>? pricesFuture;
  int pricesCreated = 0;
  int? garageId;
  final TextStyle textStyle = const TextStyle(
    fontWeight: FontWeight.w500,
  );

  void startCreatingGarage() async {
    setState(() {
      garageFuture = postGarage(context, widget.garage);
    });
    garageId = (await garageFuture!).id;
    startCreatingPrices();
  }

  void startCreatingPrices() async {
    if (garageId != null) {
      List<Future> futures = [];
      for (var price in widget.prices) {
        Future<Price> future = postPrice(
          context,
          price.copyWith(garageId: garageId!),
          garageId!,
        );
        future.then(
          (value) => setState(() {
            pricesCreated += 1;
          }),
        );
        futures.add(future);
      }
      setState(() {
        pricesFuture = Future.wait(futures);
      });

      pricesFuture?.then(
        (value) => null,
        onError: (e) => setState(
          () {
            pricesCreated = 0;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (garageFuture == null && pricesFuture == null) {
      return ElevatedButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: startCreatingGarage,
        icon: const Icon(
          Icons.check,
          size: 20,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Create garage',
            style: textStyle,
          ),
        ),
      );
    }

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildGarageFutureBuilder(),
            const SizedBox(
              height: 20,
            ),
            _buildPricesFutureBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _buildGarageFutureBuilder() {
    return FutureBuilder<void>(
      future: garageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Creating ${widget.garage.name}',
                  style: textStyle,
                ),
              ),
              const CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Creating ${widget.garage.name}',
                      style: textStyle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.red.shade900,
                    ),
                    onPressed: startCreatingGarage,
                  ),
                ],
              ),
              Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.red.shade900),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Creating ${widget.garage.name}',
                  style: textStyle,
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildPricesFutureBuilder() {
    if (pricesFuture == null) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Creating prices ($pricesCreated/${widget.prices.length})',
              style: textStyle,
            ),
          ),
        ],
      );
    }

    return FutureBuilder<void>(
      future: pricesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Creating prices ($pricesCreated/${widget.prices.length})',
                  style: textStyle,
                ),
              ),
              CircularProgressIndicator(
                value: widget.prices.isEmpty
                    ? 1
                    : pricesCreated / widget.prices.length,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Creating prices ($pricesCreated/${widget.prices.length})',
                      style: textStyle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.red.shade900,
                    ),
                    onPressed: startCreatingPrices,
                  ),
                ],
              ),
              Text(
                snapshot.error.toString(),
                style: TextStyle(color: Colors.red.shade900),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Creating prices ($pricesCreated/${widget.prices.length})',
                      style: textStyle,
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.garage.name} was created successfully!',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                onPressed: () {
                  context.pop();
                },
                child: const Text('Return'),
              )
            ],
          );
        }
      },
    );
  }
}
