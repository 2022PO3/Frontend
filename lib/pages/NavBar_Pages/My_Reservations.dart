import 'package:flutter/material.dart';

class My_Reservations extends StatefulWidget {
  @override
  State<My_Reservations> createState() => _My_ReservationsState();
}

class _My_ReservationsState extends State<My_Reservations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Reservations"),
        ),
        //Table of reservations
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(columns: <DataColumn>[
                DataColumn(
                    label: Text(
                  "Reservation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                DataColumn(
                    label: Text(
                  "Hours",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ], rows: <DataRow>[
                DataRow(cells: [
                  DataCell(Text("Reservationnumber"), onTap: () {
                    //EDIT DIRECTORY TO CORRECT RESERVATION
                    //PULL RESERVATIONNUMBER DATE HOURS AND GARAGENAME FROM RESERVATION
                    Navigator.pushNamed(context, '/home');
                  }),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ]),
                DataRow(cells: [
                  DataCell(Text("Reservationnumber")),
                  DataCell(Text("Garagename")),
                  DataCell(Text("Date")),
                  DataCell(Text("Hours"))
                ])
              ]),
            )));
  }
}
