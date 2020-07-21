import 'package:cafeteria/components/loading.dart';
import 'package:cafeteria/services/add_category.dart';
import 'package:cafeteria/screens/new_product.dart';
import 'package:cafeteria/services/Provider/user_provider.dart';
import 'package:cafeteria/components/size_cofig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Page { dashboard, manage }

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final UserProvider _auth = UserProvider.initialize();
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  String category;
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.blue,
        title: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton.icon(
                onPressed: () {
                  setState(() => _selectedPage = Page.dashboard);
                },
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedPage == Page.dashboard ? active : notActive,
                ),
                label: Text('Dashboard'),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                onPressed: () {
                  setState(() => _selectedPage = Page.manage);
                },
                icon: Icon(
                  Icons.sort,
                  color: _selectedPage == Page.manage ? active : notActive,
                ),
                label: Text('Manage'),
              ),
            ),
          ],
        ),
      ),
      body: _loadScreen(),
    );
  }

  Widget _loadScreen() {
    SizeConfig().init(context);
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.people,
                              size: SizeConfig.blockSizeHorizontal * 5,
                              color: Colors.black,
                            ),
                            label: Text("Users")),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                          onPressed: null,
                          icon: Icon(
                            Icons.category,
                            size: SizeConfig.blockSizeHorizontal * 5,
                            color: Colors.black,
                          ),
                          label: Text(
                            "Categories",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3.9),
                          ),
                        ),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.track_changes,
                              size: SizeConfig.blockSizeHorizontal * 5,
                              color: Colors.black,
                            ),
                            label: Text("Products")),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.5),
                    child: Card(
                      child: ListTile(
                        title: FlatButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.shopping_cart,
                              size: SizeConfig.blockSizeHorizontal * 5,
                              color: Colors.black,
                            ),
                            label: Text("Orders")),
                        subtitle: Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: active, fontSize: 60.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add Product"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Product List"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add Category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category List"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add User"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("User List"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Log Out"),
              onTap: () {
                {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('Are you really want to Sign Out ?'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Sign Out !',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              await _auth.signOut();
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: Text('No',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          onChanged: (textValue) {
            setState(() {
              category = textValue;
            });
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Category cannot be Empty';
            }
          },
          decoration: InputDecoration(hintText: "add category"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (category != null) {
                _categoryService.createCategory(category);
                category = null;

                Navigator.pop(context);
              } else {}
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }
}
