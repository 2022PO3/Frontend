import 'package:flutter/material.dart';

class BookingSystem extends StatefulWidget {
  const BookingSystem({super.key});

  @override
  State<BookingSystem> createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //
            ),
        body: const Text('hello')
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
