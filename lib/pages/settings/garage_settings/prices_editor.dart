import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/requests/price_requests.dart';
import 'package:po_frontend/pages/payment_widgets/timer_widget.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_settings_page.dart';
import 'package:po_frontend/pages/settings/widgets/editing_widgets.dart';
import 'package:po_frontend/utils/request_button.dart';

import '../../../api/models/enums.dart';
import '../../../api/models/garage_model.dart';
import '../../../api/models/price_model.dart';
import '../../../utils/error_widget.dart';

class PricesEditor extends StatelessWidget {
  const PricesEditor(
      {Key? key,
      required this.prices,
      required this.garageId,
      required this.onChanged})
      : super(key: key);

  final List<Price> prices;
  final int garageId;
  final Function(List<Price> prices) onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Prices',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.shortestSide / 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              ValutaSelector(
                initialValue: prices.first.valuta,
                canBeNull: false,
                onChanged: (newValue) async {
                  List<Future> futures = [];
                  for (var price in prices) {
                    futures.add(updatePrice(price.copyWith(valuta: newValue)));
                  }
                  await Future.wait(futures);
                  await onChanged.call(
                      prices.map((e) => e.copyWith(valuta: newValue)).toList());
                },
              ),
              IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('Help Prices'),
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text('To calculate the total price for a cert'
                              'ain parking duration, we start with the price wi'
                              'th the largest duration and subtract it from the'
                              ' remaining time as much as possible. After that,'
                              ' we do the same with the price with the second l'
                              'argest duration, and so on.'),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text('For example, when there are prices for 1'
                              ' day, 8 hours and 1 hour, and the customer parke'
                              'd for 12 hours, they have to pay the price for 8'
                              ' hours once and the price for 1 hour four times.'),
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () => context.pop(),
                              child: Text('Close')),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.help),
              ),
            ],
          ),
          ...prices
              .map((price) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      PriceEditorWidget(
                        price: price,
                        onChanged: (newPrice) {
                          List<Price> newPrices = List.from(prices);
                          newPrices.remove(price);
                          if (newPrice != null) {
                            newPrices.add(newPrice);
                          }
                          onChanged.call(newPrices);
                        },
                      ),
                    ],
                  ))
              .toList(),
          Center(
            child: RequestButton(
                text: 'Add new price',
                makeRequest: () async {
                  Future createFuture = Future(() => null);
                  await EditorDialog.show<Price>(
                    context,
                    fieldName: 'your new price',
                    currentValue: Price(
                      id: 0,
                      garageId: garageId,
                      priceString: '',
                      price: 1,
                      duration: const Duration(hours: 1),
                      valuta: ValutaEnum.EUR,
                    ),
                    onConfirm: (price) async {
                      createFuture = createPrice(price);
                      await createFuture;
                      onChanged([...prices, price]);
                    },
                  );
                  await createFuture;
                }),
          ),
        ],
      ),
    );
  }
}

class PriceEditorWidget extends StatefulWidget {
  const PriceEditorWidget({Key? key, required this.price, this.onChanged})
      : super(key: key);

  final Price price;

  final Function(Price? price)? onChanged;

  @override
  State<PriceEditorWidget> createState() => _PriceEditorWidgetState();
}

class _PriceEditorWidgetState extends State<PriceEditorWidget> {
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.price.priceString,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.shortestSide / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                    '${widget.price.valuta} ${widget.price.price.toStringAsFixed(2)} for ${widget.price.duration.toPrettyString(showSeconds: false)}'),
              ],
            ),
          ),
          if (!kIsWeb || isHovering)
            EditButton<Price>(
              currentValue: widget.price,
              fieldName: 'price',
              onEdit: (price) async {
                await updatePrice(price);
                widget.onChanged?.call(price);
              },
            ),
          if (!kIsWeb || isHovering)
            RequestButtonIcon(
              makeRequest: () async {
                await deletePrice(widget.price);
                widget.onChanged?.call(null);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
