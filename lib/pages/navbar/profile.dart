import 'package:flutter/material.dart';
import 'package:po_frontend/api/network/static_values.dart';
import 'package:provider/provider.dart';
import 'package:po_frontend/providers/user_provider.dart';
import 'package:po_frontend/api/network/network_helper.dart';
import 'package:po_frontend/api/network/network_service.dart';
import '../../api/network/network_exception.dart';
import 'package:po_frontend/api/models/user_model.dart';


class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final NewFirstNametextcontroller = TextEditingController();
  final NewLastNametextcontroller = TextEditingController();
  final NewEmailtextcontroller = TextEditingController();

  String userFirstName = '';
  String userLastName = '';
  String userEmail = '';


  @override
  Widget build(BuildContext context) {
    final UserProvider UserinfoPr = Provider.of<UserProvider>(context);
    Future openFirstnameDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your first name to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New first name',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            NewFirstNametextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: NewFirstNametextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      NewFirstNametextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userFirstName = NewFirstNametextcontroller.text;
                    });
                    try{
                      await setFirstName(userFirstName);
                      if (mounted) {
                        Navigator.popUntil(
                          context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    NewFirstNametextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openLastnameDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your last name to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New last name',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            NewLastNametextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: NewLastNametextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      NewLastNametextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userLastName = NewLastNametextcontroller.text;
                    });
                    try{
                      await setLastName(userLastName);
                      if (mounted) {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    NewLastNametextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    Future openEmailDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
              children: [
                const Text(
                  'Dear, ',
                  style: TextStyle(color: Colors.indigoAccent),
                ),
                Text(
                    UserinfoPr.getUser.firstName ?? 'User',
                    style: const TextStyle(color: Colors.indigoAccent)
                )
              ]
          ),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('what do you want to change your e-mail adress to?'),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'New e-mail adress',
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: IconButton(
                          onPressed: (){
                            NewEmailtextcontroller.clear();
                          },
                          icon: const Icon(Icons.clear))),
                  controller: NewEmailtextcontroller,
                )
              ]
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/profile'));
                      NewEmailtextcontroller.clear();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.indigo, fontSize: 15),
                    )),
                TextButton(
                  onPressed: () async {
                    setState((){
                      userEmail = NewEmailtextcontroller.text;
                    });
                    try{
                      await setEmail(userEmail);
                      if (mounted) {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/profile')
                        );
                      }
                    } on BackendException catch (e) {
                      print('Error occurred $e');
                    };
                    NewEmailtextcontroller.clear();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.indigo, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ));

    return Scaffold(
        appBar: AppBar(
            title: const Text('Profile')
        ),
        body: Column(
            children: [
              const Text(
                'User Info:',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Row(
                  children: [
                    const Text(
                        'User-ID: ',
                        style: TextStyle(
                          fontSize: 20,
                        )
                    ),
                    Text(
                        UserinfoPr.getUser.id.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    )
                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          const Text(
                            'First name: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                              UserinfoPr.getUser.firstName ?? 'No first name given',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ]
                    ),
                    TextButton(
                      onPressed: () {
                        openFirstnameDialog();
                      },
                      child: const Text('Change'),
                    )
                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          const Text(
                              'Last name: ',
                              style: TextStyle(
                                fontSize: 20,
                              )
                          ),
                          Text(
                              UserinfoPr.getUser.lastName ?? 'No last name given',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                          )
                        ]
                    ),
                    TextButton(
                      onPressed: (){
                        openLastnameDialog();
                      },
                      child: const Text('Change'),
                    )

                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          const Text(
                              'E-mail adress: ',
                              style: TextStyle(
                                  fontSize: 20
                              )
                          ),
                          Text(
                              UserinfoPr.getUser.email,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                          )
                        ]
                    ),
                    TextButton(
                        onPressed: (){
                          openEmailDialog();
                        },
                        child: const Text('Change')
                    )
                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  children: [
                    const Text(
                        'Province: ',
                        style: TextStyle(
                          fontSize: 20,
                        )
                    ),
                    if (UserinfoPr.getUser.location.toString() == 'null')...[
                      const Text(
                        'Not given',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]else...[
                      Text(
                        UserinfoPr.getUser.location.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  children: [
                    const Text(
                        'Id favorite garage: ',
                        style: TextStyle(
                          fontSize: 20,
                        )
                    ),
                    Text(
                      UserinfoPr.getUser.favGarageId.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ]
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                  children: const [
                    Text(
                        'Password: ',
                        style: TextStyle(
                            fontSize: 20
                        )
                    )
                  ]
              )
            ]
        )
    );
  }

  Future<bool> setFirstName(String newFirstName) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': userProvider.getUser.email,
      'role': userProvider.getUser.role,
      'firstName': newFirstName,
      'lastName': userProvider.getUser.lastName,
      'location': userProvider.getUser.location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
      requestType: RequestType.put,
      apiSlug: StaticValues.getUserSlug,
      body: body,
      useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
        callBack: User.userFromJson,
        response: response,
    );
    if (mounted){
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setLastName(String newLastName) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': userProvider.getUser.email,
      'role': userProvider.getUser.role,
      'firstName': userProvider.getUser.firstName,
      'lastName': newLastName,
      'location': userProvider.getUser.location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.getUserSlug,
        body: body,
        useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
      callBack: User.userFromJson,
      response: response,
    );
    if (mounted){
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }

  Future<bool> setEmail(String newEmail) async{
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> body = {
      'id': userProvider.getUser.id,
      'email': newEmail,
      'role': userProvider.getUser.role,
      'firstName': userProvider.getUser.firstName,
      'lastName': userProvider.getUser.lastName,
      'location': userProvider.getUser.location,
      'favGarageId': userProvider.getUser.favGarageId ?? 1,
    };
    final response = await NetworkService.sendRequest(
        requestType: RequestType.put,
        apiSlug: StaticValues.getUserSlug,
        body: body,
        useAuthToken: true
    );
    final userNew = await NetworkHelper.filterResponse(
      callBack: User.userFromJson,
      response: response,
    );
    if (mounted){
      final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userNew);
    }

    return NetworkHelper.validateResponse(response);
  }
}
