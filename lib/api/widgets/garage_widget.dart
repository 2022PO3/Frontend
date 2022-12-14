import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/garage_model.dart';
import 'package:po_frontend/api/models/location_model.dart';
import 'package:po_frontend/utils/constants.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GarageWidget extends StatelessWidget {
  const GarageWidget({
    Key? key,
    required this.garage,
  }) : super(key: key);

  final Garage garage;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.longestSide;

    return Card(
      shape: Constants.cardBorder,
      child: InkWell(
        child: Row(
          children: [
            buildFreeSpotsBanner(
              context,
              garage,
              height,
              Constants.borderRadius,
            ),
            buildGarageInformationBanner(
              context,
              garage,
              height,
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
    double height,
    double borderRadius,
  ) {
    final double width = MediaQuery.of(context).size.shortestSide;
    final double maxSpots = garage.parkingLots.toDouble();
    final double unoccupiedLots = garage.unoccupiedLots.toDouble();
    final bool full = maxSpots == unoccupiedLots;

    return Container(
      width: width / 6,
      height: height / 11,
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
              maximum: maxSpots == 0 ? 1 : maxSpots,
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
                  value: unoccupiedLots == maxSpots ? 1 : unoccupiedLots,
                  width: 0.15,
                  sizeUnit: GaugeSizeUnit.factor,
                  cornerStyle:
                      full ? CornerStyle.bothFlat : CornerStyle.bothCurve,
                  color: determineFreePlacesColor(garage),
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  angle: 90,
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (garage.parkingLots - garage.unoccupiedLots).toString(),
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
    );
  }

  Widget buildGarageInformationBanner(
    BuildContext context,
    Garage garage,
    double height,
  ) {
    final Location location = garage.garageSettings.location;
    final double width = MediaQuery.of(context).size.shortestSide;

    return SizedBox(
      height: height / 11,
      width: width - 72,
      child: Padding(
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
              Province.getProvinceName(location.province),
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
      ),
    );
  }

  Color determineFreePlacesColor(Garage garage) {
    final double ratio = garage.unoccupiedLots / garage.parkingLots;

    if (ratio <= 0.5) {
      return const Color.fromARGB(255, 16, 137, 20);
    } else if (0.5 < ratio && ratio <= 0.95) {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.red.shade600;
    }
  }
}
