import 'dart:async';

import 'package:flutter/material.dart';

import '../../api/models/enums.dart';
import '../../api/models/licence_plate_model.dart';
import '../../api/models/price_model.dart';
import '../../api/network/network_helper.dart';
import '../../api/network/network_service.dart';
import '../../api/network/static_values.dart';
import '../../utils/error_widget.dart';

class PaymentOverview extends StatefulWidget {
  /// Widget to show an overview of the bill the user has to pay. It gets the
  /// information from the payment preview backend. Using the 'refreshTime' key
  /// in the response it knows when to send another request to keep the price
  /// up-to-date.

  const PaymentOverview({
    Key? key,
    required this.licencePlate,
  }) : super(key: key);

  final LicencePlate licencePlate;

  @override
  State<PaymentOverview> createState() => _PaymentOverviewState();
}

class _PaymentOverviewState extends State<PaymentOverview> {
  late Future<Map<Price, int>> previewFuture;
  late Timer timer;

  Map<Price, int> fromPaymentPreviewJSON(Map<String, dynamic> json) {
    Map<Price, int> items = {};
    for (var item in json['items']) {
      items[Price.fromJSON(item)] = item['quantity'] as int;
    }

    timer = Timer(Duration(seconds: json['refreshTime'] + 2), reloadFuture);

    return items;
  }

  Future<Map<Price, int>> getPaymentPreview() async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        apiSlug: StaticValues.getPaymentPreviewSlug,
        useAuthToken: true,
        queryParams: {'licence_plate': widget.licencePlate.licencePlate});

    return await NetworkHelper.filterResponse(
      callBack: fromPaymentPreviewJSON,
      response: response,
    );
  }

  @override
  void initState() {
    reloadFuture();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<Map<Price, int>> reloadFuture() async {
    setState(() {
      previewFuture = getPaymentPreview();
    });

    return previewFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<Price, int>>(
      future: previewFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Map<Price, int> items = snapshot.data ?? {};
          final List entries = items.entries.toList();
          final double shortestSide = MediaQuery.of(context).size.shortestSide;

          return _buildData(context, entries, shortestSide);
        } else if (snapshot.hasError) {
          return SnapshotErrorWidget(
            snapshot: snapshot,
          );
        }
        return const Center(
          child: SizedBox.square(
            dimension: 25,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildData(
      BuildContext context, List<dynamic> entries, double shortestSide) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: reloadFuture,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics()
                      .applyTo(const BouncingScrollPhysics()),
                  itemBuilder: (BuildContext context, int index) =>
                      _PreviewItemWidget(
                    price: entries[index].key,
                    quantity: entries[index].value,
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: entries.length,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: Theme.of(context).primaryColor,
                        thickness: 2,
                      ),
                      _TotalWidget(
                          shortestSide: shortestSide, entries: entries),
                    ],
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: reloadFuture,
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 35,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TotalWidget extends StatelessWidget {
  /// Row at the bottom of the payment overview to show to total amount the user
  /// has to pay.
  const _TotalWidget({
    required this.shortestSide,
    required this.entries,
  });

  final double shortestSide;
  final List entries;

  double get _pricesSum =>
      entries.map((e) => e.key.price * e.value).reduce((a, b) => a + b)
          as double;
  String get _pricesSumString =>
      '${entries[0].key.valuta} ${(_pricesSum).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Total',
          style: TextStyle(
              fontSize: shortestSide / 25,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor
              //color: Theme.of(context).primaryColor,
              ),
        ),
        const Spacer(),
        Text(
          _pricesSumString,
          style: TextStyle(
              fontSize: shortestSide / 25,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor
              //color: Theme.of(context).primaryColor,
              ),
        ),
      ],
    );
  }
}

class _PreviewItemWidget extends StatelessWidget {
  /// Widget showing the amount of times the user has to pay a certain rate for
  /// parking in the garage (eg. €3 for 1 hour, €0,5 for 15 minutes). It also
  /// shows the total of this rate.

  const _PreviewItemWidget({
    Key? key,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  final Price price;
  final int quantity;

  String get _totalPriceString =>
      '${price.valuta} ${(price.price * quantity).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price.priceString,
                style: TextStyle(
                  fontSize: shortestSide / 25,
                  fontWeight: FontWeight.w700,
                  //color: Theme.of(context).primaryColor,
                ),
              ),
              Row(
                children: [
                  Text(_quantityString),
                ],
              ),
            ],
          ),
        ),
        Text(
          _totalPriceString,
          style: TextStyle(
            fontSize: shortestSide / 25,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  String get _quantityString => 'x $quantity';
}
