import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Supermarket Shopping List',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Color(0xFF151026)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'My Supermarket Shopping List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> items = <ListItem>[];
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Column(
                  children: [
                    Title(),
                    ListView(shrinkWrap: true, children: items),
                    EnterItems(
                        controller: textController, onPressed: _searchItem)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ShoppingLogo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontSize: 16.0)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title:
                  Text('About the Developer', style: TextStyle(fontSize: 16.0)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _addItem(String text) {
    setState(() {
      Key key = Key(text);
      final newListItem = ListItem(
        key: key,
        label: text,
        onClosed: () => _removeItem(key),
      );
      items = List.from(items..add(newListItem));
    });
  }

  _searchItem(String text) {
    setState(() {
      Key key = Key(text);
      final newListItem = ListItem(
        key: key,
        label: text,
        onClosed: () => _removeItem(key),
      );

      bool found = false;

      if (items.length == 0) {
        _addItem(text);
        found = false;
      } else {
        for (int x = 0; x < items.length; x++) {
          if (items[x].label == newListItem.label) {
            showAlertDialog(context);
            found = true;
          }
        }
        if (found == false) {
          _addItem(text);
        }
      }
    });
  }

  _removeItem(Key key) {
    setState(() {
      items = List.from(items..removeWhere((item) => item.key == key));
    });
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
  );

  AlertDialog alert = AlertDialog(
    title: Text("Repeated Entry!"),
    content: Text("The item is already in your shopping list."),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class ListItem extends StatefulWidget {
  final String label;
  final Function onClosed;

  const ListItem({Key key, this.label, this.onClosed}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    if (status == false) {
      return Container(
          child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => {
                setState(() {
                  if (status == true) {
                    status = false;
                  } else {
                    status = true;
                  }

                  _switchTextStyle();
                })
              },
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            // ),

            IconButton(
              color: Colors.red,
              onPressed: widget.onClosed,
              icon: Icon(Icons.close),
            )
          ],
        ),
      ));
    } else {
      return Container(
          child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () => {
                setState(() {
                  if (status == true) {
                    status = false;
                  } else {
                    status = true;
                  }

                  _switchTextStyle();
                })
              },
              child: Text(
                widget.label,
                style: TextStyle(
                    fontSize: 16.0, decoration: TextDecoration.lineThrough),
              ),
            ),
            // ),

            IconButton(
              color: Colors.red,
              onPressed: widget.onClosed,
              icon: Icon(Icons.close),
            )
          ],
        ),
      ));
    }
  }

  void _switchTextStyle() {
    setState(() {
      if (status == true) {
        Text(widget.label,
            style: TextStyle(
                fontSize: 18, decoration: TextDecoration.lineThrough));
      }
    });
  }
}

class Title extends StatefulWidget {
  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<Title> {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'My Shopping List',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    ]);
  }
}

class EnterItems extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onPressed;

  const EnterItems({Key key, this.controller, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            color: Colors.lightBlueAccent,
            child: Text('Add Item'),
            onPressed: () => onPressed(controller.text),
          ),
        ),
      ],
    );
  }
}

class _AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About the Developer"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 25.0, 2.0, 40.0),
                  child: Text(
                    'Meet the Developer!',
                    style: TextStyle(
                      fontSize: 35.0,
                      letterSpacing: 1.5,
                      color: Colors.white,
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/dsinclair.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Daavid Sinclair",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 310.0,
                          ),

                          //My name is Daavid A.S. Sinclair. I am a 19 year old male, who is from Jamaica.
                          Text(
                            'I am Daavid A.S. Sinclair. I am a 19 year old male, who is from Jamaica.\n\n'
                            'I am a senior at NCU. I am pursuing a Batchelors degree in Computer Science where my concentration is Software Engineering.\n\n'
                            'I am fluent in Pyton, Java, C# and C++, and I am experienced with Flask, JSP, PHP, ASP.net, Laravel and learning Flutter.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF151026);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
