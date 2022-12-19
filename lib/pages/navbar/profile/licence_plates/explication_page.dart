// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:po_frontend/core/app_bar.dart';
import 'package:po_frontend/utils/card.dart';
import 'package:po_frontend/utils/sized_box.dart';

class ExplicationPage extends StatelessWidget {
  const ExplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Licence plate registration'),
      body: Column(
        children: [
          buildCard(
            children: [
              const Text(
                'Why do we ask for a vehicle registration plate?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
          const Height(10),
          buildCard(
            children: [
              buildExplicationText(
                'The sort answer is to prevent malicious registration of licence plates, i.e. that someone registrates a licence plates which does not belong to them.',
              ),
              const Height(10),
              buildExplicationText(
                'This could potentially make it easy for a stalker to follow a person whereabouts. We at Parking Boys condemn any form of stalking and do certainly not want to cultivate this. Therefore we instituted the policy that users are obliged to upload the vehicle registration document for their licence plate.',
              ),
              const Height(10),
              buildExplicationText(
                'We know that this is not at all a convenient measure, but an absolute necessity to prevent any criminal use of our application. It\'s not a necessity to make an account at the Parking Boys\' application to make use of our services. The same user experience is guaranteed even without an account.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildExplicationText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 17,
      ),
    );
  }
}
