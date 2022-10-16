import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:po_frontend/pages/home/Garage_model.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<GarageModel> main_garages_list = [
    GarageModel("The Parking Boys", 322,4, "https://cdn.pixabay.com/photo/2014/06/04/16/36/man-362150_960_720.jpg"),
    GarageModel("Leuven", 433,3, "https://cdn.pixabay.com/photo/2016/12/24/22/09/destruction-1929422_960_720.jpg"),
    GarageModel("Antwerpen", 322,4, "https://cdn.pixabay.com/photo/2021/08/11/16/39/parking-lot-6538926_960_720.jpg"),
    GarageModel("Gent", 322,4, "https://thumbs.dreamstime.com/z/leuven-belgium-september-underground-parking-bicycles-center-leuven-city-capital-province-112859276.jpg"),
    GarageModel("Brugge", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Brussel", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Geel", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Mechelen", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Maasmechelen", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Vilvoorde", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),
    GarageModel("Machelen", 322,4, "https://cdn.pixabay.com/photo/2019/08/20/15/47/car-4419081_960_720.jpg"),

  ];
  List<GarageModel> display_list = List.from(main_garages_list);

  void updateList(String value){
    // this is the function that will filter our list
    setState(() {
      display_list = main_garages_list.where((element) => element.Garage_title!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: NavBar(),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              child: ClipOval(
                //Hier komt de profielfoto
              ),
            ),
          ),

          title: Text("[username]"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Search for....",
                  style: TextStyle(
                    color: Colors.indigo[400],
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold
                  ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) => updateList(value),
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo[400],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Give the name of the city",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.purpleAccent,
                ),
              ),
              SizedBox(height: 20.0,),
              Expanded(
                child: display_list.length == 0?Center(child: Text("No Result Found",style: TextStyle(color: Colors.indigo[400],fontSize: 22.0,fontWeight: FontWeight.bold),),):
                ListView.builder(
                  itemCount: display_list.length,
                  itemBuilder: (context,index) => ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(
                      display_list[index].Garage_title!,
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${display_list[index].garage_number!}',
                      style: TextStyle(
                          color: Colors.purple
                      ),
                    ),
                    trailing: Text(
                      "${display_list[index].rating}",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                    leading: Image.network(display_list[index].garage_poster_url!),
                    onTap: () {
                      Navigator.pushNamed(context, '/booking_system');
                    },
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}




