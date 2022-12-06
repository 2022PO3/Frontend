import 'package:flutter/material.dart';
import 'package:po_frontend/api/models/opening_hour_model.dart';
class Dayoftheweek extends StatelessWidget {
  Dayoftheweek({Key? key, required this.openingshours}) : super(key: key);
  final OpeningHour? openingshours;
  final List daysinaweek = ["Monday","Tuesday","Wednesday","Thursday",'Friday','Saturday','Sunday'];

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for(var i = openingshours!.fromDay; i <= openingshours!.toDay; i++){
      list.add(new Text(
          daysinaweek[i] + ": open from " + openingshours?.fromHour.toString() + " until " + openingshours?.toHour.toString(),
        style: TextStyle(
            color: Colors.indigo,
        ),
      )
      );
    }
    return new Column(children: list,crossAxisAlignment: CrossAxisAlignment.start,);
  }
}

