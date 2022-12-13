import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/garage_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/request_button.dart';
import 'package:po_frontend/utils/user_data.dart';
import '../../../api/models/garage_model.dart';
import '../../../api/models/garage_settings_model.dart';
import '../../../api/models/location_model.dart';
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

  Future<Future<List<Object>>> reloadFutures() async {
    setState(() {
      garageFuture = getGarage(widget.garageId);
      settingsFuture = getGarageSettings(widget.garageId);
      pricesFuture = getGaragePrices(widget.garageId);
    });
    return Future.wait([garageFuture, settingsFuture, pricesFuture]);
  }

  void setGarage(Garage garage) {
    setState(() {
      garageFuture = Future(() => garage);
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
              ),
              _LocationWidget(
                garageFuture: garageFuture,
                onChanged: (garage) => setGarage(garage),
              ),
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
        return const Center(
          child: SizedBox(),
        );
      },
    );
  }

  Widget _buildData(BuildContext context, Garage garage) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditableField(
            fieldName: 'Garage Name',
            currentValue: garage.name,
            showFieldName: false,
            valueTextStyle: TextStyle(
                fontWeight: FontWeight.w900, fontSize: shortestSide / 12),
            onEdit: (garageName) {
              updateGarage(garage.copyWith(name: garageName));
            },
          ),
          Text(
            '${garage.parkingLots - garage.unoccupiedLots} / ${garage.parkingLots}'
                .toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: shortestSide / 16),
          ),
        ],
      ),
    );
  }
}

class _LocationWidget extends StatefulWidget {
  const _LocationWidget(
      {Key? key, required this.garageFuture, required this.onChanged})
      : super(key: key);

  final Future<Garage> garageFuture;
  final Function(Garage garage)? onChanged;

  @override
  State<_LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<_LocationWidget> {
  late Future<Location> _locationFuture;
  Location? original;
  late Garage garage;

  @override
  void initState() {
    widget.garageFuture.then((value) => garage = value);
    _locationFuture =
        Future(() async => (await widget.garageFuture).garageSettings.location);
    _locationFuture.then((value) => original = value);
    super.initState();
  }

  void setLocation(Location location) {
    setState(() {
      _locationFuture = Future(() => location);
    });
  }

  TextStyle get valueTextStyle {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontSize: shortestSide / 20);
  }

  TextStyle get nameTextStyle {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontWeight: FontWeight.w500, fontSize: shortestSide / 20);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: CustomCard(
        title: 'Location',
        child: FutureBuilder<Location>(
          future: _locationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              Location location = snapshot.data as Location;
              return _buildData(context, location);
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SnapshotErrorWidget(
                  snapshot: snapshot,
                ),
              );
            }
            return original == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _buildData(context, original!);
          },
        ),
      ),
    );
  }

  Widget _buildData(BuildContext context, Location location) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditableField<String>(
            fieldName: 'Street',
            currentValue: location.street,
            nameTextStyle: nameTextStyle,
            valueTextStyle: valueTextStyle,
            onEdit: (street) => setLocation(location.copyWith(street: street)),
          ),
          EditableField<int>(
            fieldName: 'Number',
            currentValue: location.number,
            nameTextStyle: nameTextStyle,
            valueTextStyle: valueTextStyle,
            onEdit: (number) => setLocation(location.copyWith(number: number)),
          ),
          EditableField<String>(
            fieldName: 'Municipality',
            currentValue: location.municipality,
            nameTextStyle: nameTextStyle,
            valueTextStyle: valueTextStyle,
            onEdit: (municipality) =>
                setLocation(location.copyWith(municipality: municipality)),
          ),
          EditableField<int>(
            fieldName: 'Postal Code',
            currentValue: location.postCode,
            nameTextStyle: nameTextStyle,
            valueTextStyle: valueTextStyle,
            onEdit: (postCode) =>
                setLocation(location.copyWith(postCode: postCode)),
          ),
          if (original != location)
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade900),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                    ),
                    onPressed: () => setLocation(original!),
                    child: const Text('Cancel'),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: RequestButton(
                    makeRequest: () async {
                      Garage newGarage = garage.copyWith(
                          garageSettings: garage.garageSettings
                              .copyWith(location: location));

                      Garage updatedGarage = await updateGarage(newGarage);

                      widget.onChanged?.call(newGarage);
                    },
                    text: 'Confirm',
                  ),
                ),
                const Spacer(),
              ],
            )
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.child, required this.title})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0, 3.0), // shadow direction: bottom right
          )
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.shortestSide / 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(),
          child,
        ],
      ),
    );
  }
}

class EditableField<T> extends StatefulWidget {
  const EditableField({
    super.key,
    required this.fieldName,
    required this.currentValue,
    required this.onEdit,
    this.valueTextStyle,
    this.showFieldName = true,
    this.nameTextStyle,
  });

  final bool showFieldName;
  final String fieldName;
  final TextStyle? nameTextStyle;
  final T currentValue;
  final TextStyle? valueTextStyle;
  final Function(T newValue) onEdit;

  @override
  State<EditableField<T>> createState() => _EditableFieldState<T>();
}

class _EditableFieldState<T> extends State<EditableField<T>> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        isHovering = true;
      }),
      onExit: (_) => setState(() {
        isHovering = false;
      }),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.showFieldName)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${widget.fieldName}:', style: widget.nameTextStyle),
            ),
          Text(
            widget.currentValue.toString(),
            style: widget.valueTextStyle,
          ),
          if (!kIsWeb || isHovering)
            EditButton<T>(
              fieldName: widget.fieldName,
              currentValue: widget.currentValue,
              onEdit: widget.onEdit,
            ),
        ],
      ),
    );
  }
}

class EditButton<T> extends StatelessWidget {
  const EditButton({
    super.key,
    required this.currentValue,
    required this.onEdit,
    required this.fieldName,
  });

  final String fieldName;
  final T currentValue;
  final Function(T newValue) onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: IconButton(
        onPressed: () => EditorDialog.show(context,
            fieldName: fieldName,
            currentValue: currentValue,
            onConfirm: onEdit),
        icon: const Icon(Icons.edit),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class EditorDialog<T> extends StatefulWidget {
  const EditorDialog({
    super.key,
    required this.fieldName,
    this.onConfirm,
    required this.currentValue,
  });

  final String fieldName;
  final Function(T)? onConfirm;
  final T currentValue;

  @override
  State<EditorDialog<T>> createState() => _EditorDialogState<T>();

  static void show<T>(context,
      {required String fieldName,
      required T currentValue,
      Function(T)? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return EditorDialog<T>(
          fieldName: fieldName,
          currentValue: currentValue,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

class _EditorDialogState<T> extends State<EditorDialog<T>> {
  late T newValue;

  @override
  void initState() {
    newValue = widget.currentValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Edit ${widget.fieldName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
                IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close))
              ],
            ),
            _typeBuilder(),
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  onPressed: () {
                    widget.onConfirm?.call(newValue);
                    context.pop();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Builder _typeBuilder() {
    return Builder(builder: (context) {
      switch (T) {
        case String:
          final currentValue = widget.currentValue as String;
          final controller = TextEditingController(text: currentValue);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String v) => newValue = v as T,
            ),
          );

        case int:
          return SpinBox(
            min: 0,
            max: double.infinity,
            value: (widget.currentValue as int).toDouble(),
            decimals: 0,
            step: 1,
            onChanged: (v) => newValue = v.toInt() as T,
          );
        case double:
        case num:
          return SpinBox(
            min: 0,
            value: widget.currentValue as double,
            decimals: 2,
            step: 0.5,
            onChanged: (v) => newValue = v as T,
          );
        case Price:
          return SpinBox(
            min: 0,
            value: (widget.currentValue as Price).price,
            decimals: 2,
            step: 0.25,
            onChanged: (v) =>
                newValue = (newValue as Price).copyWith(price: v) as T,
          );

        default:
          throw UnimplementedError(
              'Type $T is not implemented for EditorDialog');
      }
    });
  }
}
