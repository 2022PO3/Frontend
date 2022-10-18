import 'package:flutter/material.dart';
import 'package:po_frontend/UserData/DataRequest.dart';

class Booking_System extends StatefulWidget {
  @override
  State<Booking_System> createState() => _Booking_SystemState();
}

class _Booking_SystemState extends State<Booking_System> {

  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
      ),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
