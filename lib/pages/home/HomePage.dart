import 'package:flutter/material.dart';
import 'package:po_frontend/pages/login_page.dart';
import 'NavBar.dart';
//import 'package:po_frontend/pages/home/Garage_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:po_frontend/api/garages_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

String finalEmail = '';

class Garage {
  final int id;
  final int ownerId;
  final bool is_full;
  final int unoccupied_slots;

  const Garage({
    required this.id,
    required this.ownerId,
    required this.is_full,
    required this.unoccupied_slots,
  });

//factory Album.fromJson(Map<String, dynamic> json) {
//  return Album(
//    userId: json['userId'],
//    id: json['id'],
//    title: json['title'],
//  );
//}
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  //finalEmail


  Future<List<Garage>> getGarageData() async {
    var response = await http.get(Uri.parse('http://192.168.49:8000/api/garages'));
    var jsonDataGarage = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Garage> garages = [];

      for(var g in jsonDataGarage){
        Garage garage = Garage(id: g['id'], ownerId: g['owner_id'], is_full: g['is_full'], unoccupied_slots: g['unoccupied_lots']);
        garages.add(garage);
      }
      return garages;
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  // List<Garage> main_garages_list = await getGarageData();
  // List<GarageModel> display_list = List.from(main_garages_list);
  //
  // Future updateList(String value){
  //   // this is the function that will filter our list
  //   setState(() {
  //     display_list = main_garages_list.where((element) => element.Garage_title!.toLowerCase().contains(value.toLowerCase())).toList();
  //   });
  // }

  
  @override
  void initState() {
    getValidationData();
  }

  Future getValidationData() async {
    final userInfo = await SharedPreferences.getInstance();
    var obtainedEmail = userInfo.getString('email');
    setState(() {
      finalEmail = obtainedEmail as String;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: NavBar(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [(Colors.indigo),(Colors.indigoAccent)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
            ),
          ),
          title: Center(child: Text(finalEmail)),
        ),
        body: GaragesPage()           //FutureBuilder(
          //future: getGarageData(),
          //builder: (context,snapshot) {
          //   if (snapshot.data == null) {
          //     return Container(
          //       child: Text('loading...'),
          //     );
          //   } else {
          //     return Padding(
          //       padding: EdgeInsets.all(16),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Search for....",
          //             style: TextStyle(
          //                 color: Colors.indigo[400],
          //                 fontSize: 22.0,
          //                 fontWeight: FontWeight.bold
          //             ),
          //           ),
          //           SizedBox(
          //             height: 20.0,
          //           ),
          //           TextField(
          //             onChanged: (value) => print(value),
          //             style: TextStyle(
          //               color: Colors.white,
          //             ),
          //             decoration: InputDecoration(
          //               filled: true,
          //               fillColor: Colors.indigo[400],
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(80.0),
          //                 borderSide: BorderSide.none,
          //               ),
          //               hintText: "Give the name of the city",
          //               prefixIcon: Icon(Icons.search),
          //               prefixIconColor: Colors.purpleAccent,
          //             ),
          //           ),
          //           SizedBox(height: 20.0,),
          //             ListView.builder(
          //               itemCount: snapshot.data!.length,
          //               itemBuilder: (context,index) => ListTile(
          //                 contentPadding: EdgeInsets.all(8.0),
          //                 title: Text(
          //                   snapshot.data![index].id.toString(),
          //                   style: TextStyle(
          //                     color: Colors.indigo,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 subtitle: Text(
          //                     snapshot.data![index].ownerId.toString(),
          //                   style: TextStyle(
          //                       color: Colors.indigo
          //                   ),
          //                 ),
          //                 trailing: Text(
          //                     snapshot.data![index].unoccupied_slots.toString(),
          //                   style: TextStyle(
          //                     color: Colors.indigo,
          //                   ),
          //                 ),
          //                // leading: Image.network(display_list[index].garage_poster_url!),
          //                 onTap: () {
          //                   Navigator.pushNamed(context, '/booking_system');
          //                 },
          //               ),
          //             ),
          //         ],
          //       ),
          //     );
          //   }
           //}
        //)
    );
  }
}




