import 'package:flutter/material.dart';
import 'package:fyp_project/screens/FormScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supervisor Willingness Form'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: FormScreen(),
      ),
    );
  }
}
