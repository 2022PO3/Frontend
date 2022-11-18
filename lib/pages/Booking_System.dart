import 'package:flutter/material.dart';

class Booking_System extends StatefulWidget {
  @override
  State<Booking_System> createState() => _Booking_SystemState();
}

class _Booking_SystemState extends State<Booking_System> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
      ),
      body: Text('hello')
      //   child: FutureBuilder<Album>(
      //     future: futureAlbum,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return Text(snapshot.data!.title);
      //       } else if (snapshot.hasError) {
      //         return Text('${snapshot.error}');
      //       }
      //       return const CircularProgressIndicator();
      //     },
      //   ),
      // ),
    );
  }
}
