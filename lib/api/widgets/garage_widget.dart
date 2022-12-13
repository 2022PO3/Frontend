import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              Constants.cardBorderRadius,
            ),
            buildGarageInformationBanner(
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
    final bool full = garage.parkingLots == garage.unoccupiedLots;
    final bannerText = full ? 'Full!' : 'Free';
    final int freeSpots = garage.parkingLots - garage.unoccupiedLots;

    return Container(
      width: width / 6,
      height: height / 11,
      decoration: BoxDecoration(
        color: determineFreePlacesColor(garage),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          left: 5,
          right: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              bannerText,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  freeSpots.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  width: 1,
                ),
                const Text(
                  '/',
                ),
                const SizedBox(
                  width: 1,
                ),
                Text(
                  garage.parkingLots.toString(),
                ),
              ],
            ),
            SizedBox(
              height: width / 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGarageInformationBanner(Garage garage, double height) {
    final Location location = garage.garageSettings.location;
    const TextStyle locationTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
    );

    return SizedBox(
      height: height / 11,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
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
              '${location.street} ${location.number}',
              style: locationTextStyle,
            ),
            Text(
              '${location.municipality}, ${location.postCode}',
              style: locationTextStyle,
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
