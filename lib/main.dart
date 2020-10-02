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
        appBarTheme: AppBarTheme(color: Color.fromRGBO(0, 0, 128, 1)),
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
            IconButton(
              color: Colors.red,
              onPressed: () {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Item Removed.'),
                );
                widget.onClosed();

                Scaffold.of(context).showSnackBar(snackBar);
              },
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
            IconButton(
              color: Colors.red,
              onPressed: () {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Item Removed.'),
                );
                widget.onClosed();

                Scaffold.of(context).showSnackBar(snackBar);
              },
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
  final String _fullName = "Daavid Sinclair";
  final String _status = "Software Engineer";
  final String _bio =
      "\"I am Daavid A.S. Sinclair. I am a 19 year old male, who is from Jamaica."
      "I am a senior at NCU. I am pursuing a Batchelors degree in Computer Science where my concentration is Software Engineering.\"";
  final String _projects = "5";
  final String _age = "19";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 160.0,
        height: 160.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dsinclair.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: Colors.white,
            width: 4.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
      child: Text(
        _fullName,
        style: _nameTextStyle,
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildSkills(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        skill,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildSkillItem(String label) {
    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: _statCountTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 18.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Major Projects", _projects),
          _buildStatItem("Age", _age),
        ],
      ),
    );
  }

  Widget _buildSkillContainer() {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 2.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildSkillItem("Skills"),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      //fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("About the Developer"),
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 10.4),
                  _buildProfileImage(),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildFullName(),
                        _buildStatus(context),
                        _buildStatContainer(),
                        _buildBio(context),
                        _buildSeparator(screenSize),
                        _buildSkillContainer(),
                        _buildSkills(
                            "C#, C++, Python, Java, Dart, ASP.net, Flask, PHP, Laravel, Flutter")
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
