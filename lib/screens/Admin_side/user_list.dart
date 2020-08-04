import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:cafeteria/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<DocumentSnapshot> users = <DocumentSnapshot>[];
  UserServices _userServices = UserServices();

  bool loading = true;

  void initState() {
    _getUsers();
  }

  _getUsers() async {
    List<DocumentSnapshot> data = await _userServices.getUsers();
    setState(() {
      users = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading4()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                "User List",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/app_bac.jpg'),
                fit: BoxFit.fill,
              )),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.indigo,
                            Colors.blueAccent,
                            Colors.indigo,
                          ],
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          users[index].data['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          _userAlert(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  void _userAlert(int index) {
    var alert = new AlertDialog(
      title: Text('User Details'),
      content: Container(
        height: SizeConfig.safeBlockVertical * 13.5,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Text(
                  "Name :",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockVertical * 2,
                ),
                Text(
                  users[index].data['name'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            new Row(
              children: <Widget>[
                Text(
                  "Email :",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockVertical * 2,
                ),
                Text(
                  users[index].data['email'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            new Row(
              children: <Widget>[
                Text(
                  "Id :",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 2,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockVertical * 2,
                ),
                Text(
                  users[index].data['userId'],
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockVertical * 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
