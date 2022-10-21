// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// String URl_garage_data = "http://192.168.49.1:8000/api/garages/";
//
// Future<Garage> fetchAlbum() async {
//   var response = await http
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
//   var jsonDataGarage = jsonDecode(response.body);
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     List<Garage> garages = [];
//
//     for(var g in jsonDataGarage){
//       Garage garage = Garage(id: g['id'], ownerId: g['owner_id'], is_full: g['is_full'], unoccupied_slots: g['unoccupied_lots']);
//       garages.add(garage);
//     }
//     return garages;
//     // return Album.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
//
// class Garage {
//   final int id;
//   final int ownerId;
//   final bool is_full;
//   final int unoccupied_slots;
//
//   const Garage({
//     required this.id,
//     required this.ownerId,
//     required this.is_full,
//     required this.unoccupied_slots,
//   });
//
//   //factory Album.fromJson(Map<String, dynamic> json) {
//   //  return Album(
//   //    userId: json['userId'],
//   //    id: json['id'],
//   //    title: json['title'],
//   //  );
//   //}
// }
//
