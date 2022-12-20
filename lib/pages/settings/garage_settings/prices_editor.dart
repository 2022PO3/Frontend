// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:go_router/go_router.dart';
// Project imports:
import 'package:po_frontend/api/models/enums.dart';
import 'package:po_frontend/api/models/price_model.dart';
import 'package:po_frontend/pages/payment_widgets/timer_widget.dart';
import 'package:po_frontend/pages/settings/garage_settings/garage_settings_page.dart';
import 'package:po_frontend/pages/settings/widgets/editing_widgets.dart';
import 'package:po_frontend/utils/request_button.dart';

class PricesEditor extends StatefulWidget {
  const PricesEditor({
    Key? key,
    required this.prices,
    this.onPriceChanged,
    this.onValutaChanged,
    this.onDelete,
  }) : super(key: key);

  final List<Price> prices;
  final Function(Price price)? onPriceChanged;
  final Function(Price price)? onDelete;
  final Function(ValutaEnum valuta)? onValutaChanged;

  @override
  State<PricesEditor> createState() => _PricesEditorState();
}

class _PricesEditorState extends State<PricesEditor> {
  bool _showSameDurationError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PricesEditor oldWidget) {
    _showSameDurationError = false;
    super.didUpdateWidget(oldWidget);
  }

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
              const Spacer(),
              RequestValutaSelector(
                initialValue: widget.prices.isNotEmpty
                    ? widget.prices.first.valuta
                    : ValutaEnum.EUR,
                canBeNull: false,
                onChanged: (newValue) async {
                  if (newValue != null) {
                    await widget.onValutaChanged?.call(newValue);
                  }
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
                              child: const Text('Close')),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.help),
              ),
            ],
          ),
          ...widget.prices
              .map((price) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      PriceEditorWidget(
                        isDuplicate: widget.prices
                                .where((e) => e.duration == price.duration)
                                .length >=
                            2,
                        price: price,
                        onChanged: (price) {
                          print(widget.prices.map((e) => null));
                          if (widget.prices
                                  .where((e) =>
                                      e.duration == price.duration &&
                                      e.price != price.price)
                                  .length >=
                              2) {
                            setState(() {
                              _showSameDurationError = true;
                            });
                          } else {
                            widget.onPriceChanged?.call(price);
                          }
                        },
                        onDelete: () => widget.onDelete?.call(price),
                      ),
                    ],
                  ))
              .toList(),
          if (_showSameDurationError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'A price with the same duration and different price already exists for this garage.',
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
          Center(
            child: RequestButton(
              text: 'Add new price',
              makeRequest: () async {
                Future createFuture = Future(() => null);
                await EditorDialog.show<Price>(
                  context,
                  fieldName: 'your new price',
                  currentValue: Price(
                    id: -1,
                    priceString: '',
                    price: 1,
                    duration: const Duration(hours: 1),
                    valuta: ValutaEnum.EUR,
                  ),
                  onConfirm: (price) async {
                    if (widget.prices
                        .where((e) =>
                            e.duration == price.duration &&
                            e.price != price.price)
                        .isNotEmpty) {
                      setState(() {
                        _showSameDurationError = true;
                      });
                    } else {
                      await widget.onPriceChanged?.call(price);
                    }
                  },
                );
                await createFuture;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PriceEditorWidget extends StatefulWidget {
  const PriceEditorWidget(
      {Key? key,
      required this.price,
      this.onChanged,
      required this.onDelete,
      required this.isDuplicate})
      : super(key: key);

  final Price price;

  final bool isDuplicate;

  final Function(Price price)? onChanged;
  final Function onDelete;

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
                  '${widget.price.valuta} ${widget.price.price.toStringAsFixed(2)} for ${widget.price.duration.toPrettyString(showSeconds: false)}',
                ),
                if (widget.isDuplicate)
                  Text(
                    'Another price has the same duration.',
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                if (widget.price.priceString.trim() == '')
                  Text(
                    'The price should have a title.',
                    style: TextStyle(color: Colors.red.shade900),
                  ),
              ],
            ),
          ),
          if (!kIsWeb || isHovering)
            EditButton<Price>(
              currentValue: widget.price,
              fieldName: 'price',
              onEdit: (price) async => await widget.onChanged?.call(price),
            ),
          if (!kIsWeb || isHovering)
            RequestButtonIcon(
              makeRequest: () async => widget.onDelete(),
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
