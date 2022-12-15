import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:go_router/go_router.dart';
import 'package:po_frontend/api/models/credit_card_model.dart';
import 'package:po_frontend/api/requests/user_requests.dart';
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/pages/payment_widgets/pay_button.dart';

import '../../../utils/request_button.dart';
import '../../../utils/user_data.dart';

class AddAutomaticPaymentPage extends StatefulWidget {
  const AddAutomaticPaymentPage({Key? key}) : super(key: key);

  static const route = '/home/settings/add-automatic-payment';

  @override
  State<AddAutomaticPaymentPage> createState() =>
      _AddAutomaticPaymentPageState();
}

class _AddAutomaticPaymentPageState extends State<AddAutomaticPaymentPage> {
  late CreditCard card;
  bool isCvvFocused = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    card = CreditCard.empty(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: appBar(title: 'Add automatic payment'),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor,
                  ),
                  child: CreditCardWidget(
                    glassmorphismConfig: Glassmorphism.defaultConfig(),
                    cardNumber: card.number,
                    expiryDate: card.shortExpDate,
                    cvvCode: card.cvc,
                    cardHolderName: '',
                    showBackView: isCvvFocused,
                    obscureCardNumber: false,
                    obscureCardCvv: false,
                    isHolderNameVisible: true,
                    cardBgColor: primaryColor,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange: (_) {},
                  ),
                ),
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: false,
                obscureNumber: false,
                cardNumber: card.number,
                cvvCode: card.cvc,
                cardHolderName: '',
                isHolderNameVisible: false,
                expiryDate: card.shortExpDate,
                onCreditCardModelChange: onCreditCardModelChange,
                themeColor: primaryColor,
                cardNumberDecoration: getInputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  primaryColor: primaryColor,
                ),
                expiryDateDecoration: getInputDecoration(
                  labelText: 'Expiration Date',
                  hintText: 'XX/XX',
                  primaryColor: primaryColor,
                ),
                cvvCodeDecoration: getInputDecoration(
                  labelText: 'CVC',
                  hintText: 'XXX',
                  primaryColor: primaryColor,
                ),
                cardHolderDecoration: getInputDecoration(
                  labelText: 'Card Holder',
                  primaryColor: primaryColor,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: RequestButton<void>(
                    text: 'Add Card',
                    makeRequest: () async {
                      if (formKey.currentState!.validate()) {
                        await addAutomaticPayment(card);
                        context.pop();
                        await updateUserInfo(context);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(
      {required Color primaryColor, String? hintText, String? labelText}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: TextStyle(color: primaryColor),
      focusColor: primaryColor,
      hintText: hintText,
      labelText: labelText,
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      if (creditCardModel != null) {
        card = CreditCard.fromCardFormCreditCardModel(creditCardModel);
        isCvvFocused = creditCardModel.isCvvFocused;
      } else {
        card = CreditCard.empty(context);
        isCvvFocused = false;
      }
    });
  }
}
