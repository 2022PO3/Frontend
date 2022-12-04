import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/licence_plate_model.dart';
import 'package:po_frontend/pages/payment_widgets/pay_button.dart';

import '../../api/models/enums.dart';
import '../../api/models/garage_model.dart';
import '../../api/models/price_model.dart';
import '../../api/network/network_helper.dart';
import '../../api/network/network_service.dart';
import '../../api/network/static_values.dart';
import '../error_widget.dart';
import '../payment_widgets/timer_widget.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage(
      {Key? key, required this.licencePlate, required this.garage})
      : super(key: key);

  final LicencePlate licencePlate;
  final Garage garage;

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              title: const Text('Checkout'),
            ),
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _Header(
                  garage: garage,
                  licencePlate: licencePlate,
                  shortestSide: shortestSide),
              //const Divider(),
              const Spacer(),
              Expanded(
                  flex: 20,
                  child: PaymentOverview(
                    licencePlate: licencePlate,
                  )),
              // const Divider(),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  if (kIsWeb)
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(StadiumBorder()),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red.shade900)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  if (kIsWeb) const Spacer(),
                  Expanded(
                    flex: 4,
                    child: PayButton(
                      licencePlate: licencePlate,
                      garage: garage,
                      isPreview: false,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.garage,
    required this.licencePlate,
    required this.shortestSide,
  });

  final Garage garage;
  final LicencePlate licencePlate;
  final double shortestSide;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${kIsWeb ? 'Checkout ' : ''}${garage.name}',
              maxLines: 3,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.shortestSide / 12),
            ),
          ),
        ),
        TimerWidget(
          start: licencePlate.updatedAt,
          textStyle: TextStyle(
              fontSize: shortestSide / 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 8,
        )
      ],
    );
  }
}

class PaymentOverview extends StatefulWidget {
  const PaymentOverview({Key? key, required this.licencePlate})
      : super(key: key);

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
        queryParams: {'licence_plate': widget.licencePlate.licencePlate}
        //    body: body
        );

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

  void reloadFuture() async {
    setState(() {
      previewFuture = getPaymentPreview();
    });
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
                      onRefresh: () {
                        reloadFuture();
                        return previewFuture;
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics()
                            .applyTo(BouncingScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) =>
                            PreviewItemWidget(
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
}

class _TotalWidget extends StatelessWidget {
  const _TotalWidget({
    super.key,
    required this.shortestSide,
    required this.entries,
  });

  final double shortestSide;
  final List entries;

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
          '${Valuta.getValutaSymbol(entries[0].key.valuta)} ${(entries.map((e) => e.key.price * e.value).reduce((a, b) => a + b) as double).toStringAsFixed(2)}',
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

class PreviewItemWidget extends StatelessWidget {
  const PreviewItemWidget(
      {Key? key, required this.price, required this.quantity})
      : super(key: key);

  final Price price;
  final int quantity;

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
                  Text('x $quantity'),
                ],
              ),
            ],
          ),
        ),
        Text(
          '${Valuta.getValutaSymbol(price.valuta)} ${(price.price * quantity).toStringAsFixed(2)}',
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
