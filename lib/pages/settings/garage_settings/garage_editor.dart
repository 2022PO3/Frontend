import 'package:flutter/material.dart';

import '../../../api/models/enums.dart';
import '../../../api/models/garage_model.dart';
import '../../../api/models/garage_settings_model.dart';
import '../../../api/models/location_model.dart';
import '../../../utils/request_button.dart';
import '../widgets/editing_widgets.dart';
import 'garage_settings_page.dart';

class GarageEditor extends StatefulWidget {
  const GarageEditor(
      {Key? key, required this.original, required this.onChanged})
      : super(key: key);

  final Garage original;
  final Future Function(Garage garage) onChanged;

  @override
  State<GarageEditor> createState() => _GarageEditorState();
}

class _GarageEditorState extends State<GarageEditor> {
  late Garage garage;

  @override
  void initState() {
    garage = widget.original;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationEditorWidget(
          original: widget.original.garageSettings.location,
          currentValue: garage.garageSettings.location,
          onChanged: (Location location) async {
            setState(() {
              garage = garage.copyWith(
                  garageSettings:
                      garage.garageSettings.copyWith(location: location));
            });
          },
          onConfirm: (Location location) async {
            await widget.onChanged(garage.copyWith(
                garageSettings:
                    garage.garageSettings.copyWith(location: location)));
          },
        ),
        const SizedBox(
          height: 20,
        ),
        GarageDetailsEditorWidget(
          original: widget.original.garageSettings,
          currentValue: garage.garageSettings,
          onChanged: (GarageSettings settings) async {
            setState(() {
              garage = garage.copyWith(garageSettings: settings);
            });
          },
          onConfirm: (GarageSettings settings) async {
            await widget.onChanged(garage.copyWith(garageSettings: settings));
          },
        )
      ],
    );
  }
}

class LocationEditorWidget extends StatelessWidget {
  const LocationEditorWidget({
    Key? key,
    required this.original,
    required this.onChanged,
    required this.onConfirm,
    required this.currentValue,
    this.showTitle = true,
  }) : super(key: key);

  final bool showTitle;
  final Location original;
  final Location currentValue;
  final Function(Location location) onChanged;
  final Future Function(Location location) onConfirm;

  void setLocation(Location location) async {
    onChanged(location);
  }

  TextStyle valueTextStyle(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontSize: shortestSide / 20);
  }

  TextStyle nameTextStyle(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontWeight: FontWeight.w500, fontSize: shortestSide / 20);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: showTitle ? 'Location' : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditableField<String>(
            fieldName: 'Street',
            currentValue: currentValue.street,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (street) =>
                setLocation(currentValue.copyWith(street: street)),
          ),
          EditableField<int>(
            fieldName: 'Number',
            currentValue: currentValue.number,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (number) =>
                setLocation(currentValue.copyWith(number: number)),
          ),
          EditableField<String>(
            fieldName: 'Municipality',
            currentValue: currentValue.municipality,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (municipality) =>
                setLocation(currentValue.copyWith(municipality: municipality)),
          ),
          EditableField<int>(
            fieldName: 'Postal Code',
            currentValue: currentValue.postCode,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (postCode) =>
                setLocation(currentValue.copyWith(postCode: postCode)),
          ),
          EditableField<ProvinceEnum>(
            fieldName: 'Province',
            currentValue: currentValue.province,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (province) =>
                setLocation(currentValue.copyWith(province: province)),
          ),
          EditableField<String>(
            fieldName: 'Country',
            currentValue: currentValue.country,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (country) =>
                setLocation(currentValue.copyWith(country: country)),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            clipBehavior: Clip.none,
            child: AnimatedOpacity(
              opacity: original != currentValue ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: original != currentValue
                  ? Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade900),
                              shape: MaterialStateProperty.all(
                                  const StadiumBorder()),
                            ),
                            onPressed: () => onConfirm.call(original),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: RequestButton(
                            makeRequest: () async {
                              await onConfirm.call(currentValue);
                            },
                            text: 'Confirm',
                          ),
                        ),
                        const Spacer(),
                      ],
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class GarageDetailsEditorWidget extends StatelessWidget {
  const GarageDetailsEditorWidget({
    Key? key,
    required this.onChanged,
    required this.original,
    required this.currentValue,
    required this.onConfirm,
    this.showTitle = true,
  }) : super(key: key);

  final bool showTitle;
  final GarageSettings original;
  final GarageSettings currentValue;
  final Function(GarageSettings settings) onChanged;
  final Future Function(GarageSettings settings) onConfirm;

  void setSettings(GarageSettings settings) async {
    await onChanged(settings);
  }

  TextStyle valueTextStyle(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontSize: shortestSide / 20);
  }

  TextStyle nameTextStyle(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return TextStyle(fontWeight: FontWeight.w500, fontSize: shortestSide / 20);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: showTitle ? 'Details' : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditableField<int>(
            fieldName: 'Handicapped lots',
            currentValue: currentValue.maxHandicappedLots,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (maxHandicappedLots) => setSettings(
                currentValue.copyWith(maxHandicappedLots: maxHandicappedLots)),
          ),
          EditableField<int>(
            fieldName: 'Electric cars',
            currentValue: currentValue.electricCars,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (electricCars) =>
                setSettings(currentValue.copyWith(electricCars: electricCars)),
          ),
          const Divider(),
          EditableField<double>(
            fieldName: 'Maximum Height',
            currentValue: currentValue.maxHeight,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (maxHeight) =>
                setSettings(currentValue.copyWith(maxHeight: maxHeight)),
          ),
          EditableField<double>(
            fieldName: 'Maximum Height',
            currentValue: currentValue.maxWidth,
            nameTextStyle: nameTextStyle(context),
            valueTextStyle: valueTextStyle(context),
            onEdit: (maxWidth) =>
                setSettings(currentValue.copyWith(maxWidth: maxWidth)),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            clipBehavior: Clip.none,
            child: AnimatedOpacity(
              opacity: original != currentValue ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: original != currentValue
                  ? Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.red.shade900),
                              shape: MaterialStateProperty.all(
                                  const StadiumBorder()),
                            ),
                            onPressed: () => setSettings(original),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: RequestButton(
                            makeRequest: () async {
                              await onConfirm.call(currentValue);
                            },
                            text: 'Confirm',
                          ),
                        ),
                        const Spacer(),
                      ],
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
