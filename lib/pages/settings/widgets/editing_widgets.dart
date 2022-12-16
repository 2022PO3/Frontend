import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/pages/payment_widgets/timer_widget.dart';
import 'package:po_frontend/utils/request_button.dart';

import '../../../api/models/enums.dart';
import '../../../api/models/price_model.dart';

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

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        isHovering = true;
      }),
      onExit: (_) => setState(() {
        isHovering = false;
      }),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.showFieldName)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${widget.fieldName}:',
                        style: widget.nameTextStyle),
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
          ),
        ),
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
      child: RequestButtonIcon(
        makeRequest: () async => await EditorDialog.show(context,
            fieldName: fieldName,
            currentValue: currentValue,
            onConfirm: (newValue) async => await onEdit.call(newValue)),
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
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

  static Future<void> show<T>(context,
      {required String fieldName,
      required T currentValue,
      Function(T)? onConfirm}) async {
    await showDialog(
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
        child: SingleChildScrollView(
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
              LayoutBuilder(builder: (context, constraints) {
                print(constraints.maxHeight);
                return _typeBuilder();
              }),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            const StadiumBorder(),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red.shade900)),
                      onPressed: context.pop,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: RequestButton(
                      makeRequest: () async {
                        await widget.onConfirm?.call(newValue);
                        context.pop();
                      },
                      text: 'Confirm',
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Builder _typeBuilder() {
    return Builder(builder: (context) {
      switch (T) {
        case String:
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: newValue as String,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String v) => setState(() {
                newValue = v as T;
              }),
            ),
          );

        case int:
          return SpinBox(
            min: 0,
            max: double.infinity,
            value: (newValue as int).toDouble(),
            decimals: 0,
            step: 1,
            onChanged: (v) => setState(() {
              newValue = v.toInt() as T;
            }),
          );
        case double:
        case num:
          return SpinBox(
            min: 0,
            value: newValue as double,
            decimals: 2,
            step: 0.1,
            onChanged: (v) => setState(() {
              newValue = v as T;
            }),
          );
        case Price:
          return PriceEditor(
            price: newValue as Price,
            onChanged: (v) => setState(() {
              newValue = v as T;
            }),
          );
        case ProvinceEnum:
          return ProvinceSelector(
            canBeNull: false,
            initialValue: newValue as ProvinceEnum,
            onChanged: (v) => setState(() {
              newValue = v as T;
            }),
          );

        default:
          throw UnimplementedError(
              'Type $T is not implemented for EditorDialog');
      }
    });
  }
}

class PriceEditor extends StatefulWidget {
  const PriceEditor({Key? key, required this.price, required this.onChanged})
      : super(key: key);

  final Price price;
  final Function(Price price) onChanged;

  @override
  State<PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<PriceEditor> {
  BaseUnit unit = BaseUnit.hour;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAmountEditor(),
          _buildTimeEditor(),
          _buildPriceStringEditor()
        ],
      ),
    );
  }

  Widget _buildAmountEditor() {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Customers have to pay',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.of(context).size.shortestSide / 20),
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            Text(
              widget.price.valuta.symbol,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.shortestSide / 14,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: SpinBox(
                min: 0,
                value: widget.price.price,
                decimals: 2,
                step: 0.1,
                onChanged: (v) => widget.onChanged(
                  widget.price.copyWith(price: v),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeEditor() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'For staying ${widget.price.duration.toPrettyString(showSeconds: false)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.shortestSide / 20,
              ),
            ),
          ),
        ),
        CupertinoSlidingSegmentedControl<BaseUnit>(
          backgroundColor: CupertinoColors.systemGrey2,
          //thumbColor: skyColors[_selectedSegment]!,
          // This represents the currently selected segmented control.
          groupValue: unit,
          // Callback that sets the selected segmented control.
          onValueChanged: (BaseUnit? value) {
            if (value != null) {
              setState(() {
                unit = value;
              });
            }
          },
          children: const {
            BaseUnit.hour: Text('Hours'),
            BaseUnit.minute: Text('Minutes'),
          },
        ),
        DurationPicker(
            key: ValueKey(unit),
            duration: widget.price.duration,
            onChange: (d) => widget.onChanged(
                  widget.price.copyWith(
                    duration: d,
                  ),
                ),
            snapToMins: 1,
            baseUnit: unit),
      ],
    );
  }

  Widget _buildPriceStringEditor() {
    return TextFormField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title of price',
          hintText: 'Title'),
      key: ValueKey(widget.price.id),
      initialValue: widget.price.priceString,
      onChanged: (newValue) => widget.onChanged(
        widget.price.copyWith(
          priceString: newValue,
        ),
      ),
    );
  }
}

class ProvinceSelector extends StatelessWidget {
  const ProvinceSelector({
    super.key,
    this.initialValue,
    this.onChanged,
    this.canBeNull = true,
  });

  final bool canBeNull;
  final ProvinceEnum? initialValue;
  final void Function(ProvinceEnum? province)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ProvinceEnum?>(
        hint: const Text('Select your province here'),
        value: initialValue,
        items: [
          if (canBeNull && initialValue != null)
            const DropdownMenuItem<ProvinceEnum>(
              value: null,
              child: Text('No Province'),
            ),
          ...ProvinceEnum.values.map((e) {
            return DropdownMenuItem<ProvinceEnum>(
              value: e,
              child: Text(e.name),
            );
          }).toList()
        ],
        onChanged: (newValue) {
          onChanged?.call(newValue);
        });
  }
}

class RequestValutaSelector extends StatefulWidget {
  const RequestValutaSelector(
      {Key? key, required this.canBeNull, this.initialValue, this.onChanged})
      : super(key: key);

  @override
  State<RequestValutaSelector> createState() => _RequestValutaSelectorState();

  final bool canBeNull;
  final ValutaEnum? initialValue;
  final Future<void> Function(ValutaEnum? valuta)? onChanged;
}

class _RequestValutaSelectorState extends State<RequestValutaSelector> {
  Future<void>? future;

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return _buildSelector(context);
    }

    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'The action failed: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
              _buildSelector(context)
            ],
          );
        } else {
          return _buildSelector(context);
        }
      },
    );
  }

  Widget _buildSelector(context) {
    return ValutaSelector(
      initialValue: widget.initialValue,
      canBeNull: widget.canBeNull,
      onChanged: (valuta) {
        setState(() {
          future = widget.onChanged?.call(valuta);
        });
      },
    );
  }
}

class ValutaSelector extends StatelessWidget {
  const ValutaSelector({
    super.key,
    this.initialValue,
    this.onChanged,
    this.canBeNull = true,
  });

  final bool canBeNull;
  final ValutaEnum? initialValue;
  final void Function(ValutaEnum? valuta)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ValutaEnum?>(
        hint: (canBeNull || initialValue == null)
            ? const Text('Select Currency')
            : null,
        value: initialValue,
        items: [
          if (canBeNull && initialValue != null)
            const DropdownMenuItem<ValutaEnum>(
              value: null,
              child: Text(''),
            ),
          ...ValutaEnum.values.map((e) {
            return DropdownMenuItem<ValutaEnum>(
              value: e,
              child: Text('${e.name} (${e.symbol})'),
            );
          }).toList()
        ],
        onChanged: (newValue) {
          onChanged?.call(newValue);
        });
  }
}
