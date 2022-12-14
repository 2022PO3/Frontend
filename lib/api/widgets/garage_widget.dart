// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// Project imports:
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/location_model.dart';
import 'package:po_frontend/utils/constants.dart';

class GarageWidget extends StatelessWidget {
  const GarageWidget({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Constants.cardBorder,
      child: InkWell(
        child: Row(
          children: [
            Expanded(
              child: buildFreeSpotsBanner(
                context,
                garage,
                Constants.borderRadius,
              ),
            ),
            Expanded(
              flex: 4,
              child: buildGarageInformationBanner(
                context,
                garage,
                // height,
              ),
            ),
          ],
        ),
        onTap: () {
          context.push('/home/garage-info/${garage.id}');
        },
      ),
    );
  }

  Widget buildFreeSpotsBanner(
    BuildContext context,
    Garage garage,
    double borderRadius,
  ) {
    final double ratio =
        garage.maxSpots == 0 ? 0 : garage.occupiedLots / garage.maxSpots;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(borderRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                startAngle: 270,
                endAngle: 270,
                minimum: 0,
                maximum: garage.maxSpots.toDouble(),
                showLabels: false,
                showTicks: false,
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.15,
                  cornerStyle: CornerStyle.bothFlat,
                  color: Colors.grey,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: garage.occupiedLots.toDouble(),
                    width: 0.15,
                    sizeUnit: GaugeSizeUnit.factor,
                    cornerStyle: garage.isFull
                        ? CornerStyle.bothFlat
                        : CornerStyle.bothCurve,
                    color: determineFreePlacesColor(garage, ratio),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    angle: 90,
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (garage.maxSpots-garage.occupiedLots).toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('left'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGarageInformationBanner(
    BuildContext context,
    Garage garage,
  ) {
    final Location location = garage.garageSettings.location;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            garage.name,
            style: TextStyle(
              color: Colors.indigo.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            location.province.toString(),
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          AutoSizeText(
            '${location.street} ${location.number}, ${location.municipality}, ${location.postCode}',
            maxLines: 1,
            maxFontSize: 14,
            minFontSize: 5,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Color determineFreePlacesColor(Garage garage, double ratio) {
  if (ratio <= 0.5) {
    return const Color.fromARGB(255, 16, 137, 20);
  } else if (0.5 < ratio && ratio <= 0.85) {
    return Colors.deepOrangeAccent;
  } else {
    return Colors.red.shade600;
  }
}
