import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/constants/constant.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String _student_one_name = "";
  String _student_one_github = "";
  String _student_one_reg = "";

  String _student_two_name = "";
  String _student_two_github = "";
  String _student_two_reg = "";

  String _supervisor_name = "";
  String _supervisor_github = "";

  bool _submitted = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var _selectedValue = null;

  Widget _build_student_one_name() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 1 Name'),
      validator: (value) {
        if (value.toString().isEmpty) {
          return "Name is Required";
        }
      },
      onChanged: (newValue) => {
        setState(() => {_student_one_name = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_one_name = newValue.toString()})
      },
    );
  }

  Widget _build_student_one_github() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 1 github username'),
      validator: (value) {
        if (value.toString().isEmpty) {
          return "github is Required";
        }
      },
      onChanged: (newValue) => {
        setState(() => {_student_one_github = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_one_github = newValue.toString()})
      },
    );
  }

  Widget _build_student_one_reg() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 1 registeration #'),
      validator: (value) {
        if (value.toString().isEmpty) {
          return "Registeration No. is Required";
        }
      },
      onChanged: (newValue) => {
        setState(() => {_student_one_reg = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_one_reg = newValue.toString()})
      },
    );
  }

  Widget _build_student_two_name() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 2 Name'),
      onChanged: (newValue) => {
        setState(() => {_student_two_name = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_two_name = newValue.toString()})
      },
    );
  }

  Widget _build_student_two_github() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 2 github username'),
      onChanged: (newValue) => {
        setState(() => {_student_two_github = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_two_github = newValue.toString()})
      },
    );
  }

  Widget _build_student_two_reg() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Student 2 registeration num'),
      onChanged: (newValue) => {
        setState(() => {_student_two_reg = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_student_two_reg = newValue.toString()})
      },
    );
  }

  Widget _build_supervisor_name() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'supervisor name'),
      validator: (value) {
        if (value.toString().isEmpty) {
          return "Name is Required";
        }
      },
      onChanged: (newValue) => {
        setState(() => {_supervisor_name = newValue.toString()})
      },
      onSaved: (newValue) => {
        setState(() => {_supervisor_name = newValue.toString()})
      },
    );
  }

  Widget _build_supervisor_github() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'supervisor github'),
      validator: (value) {
        if (value.toString().isEmpty) {
          return "github is Required";
        }
      },
      onChanged: (newValue) => {
        setState(() => {
              _supervisor_github = newValue.toString(),
            })
      },
      onSaved: (newValue) => {
        setState(() => {_supervisor_github = newValue.toString()})
      },
    );
  }

  Stream _projects =
      FirebaseFirestore.instance.collection("projects").snapshots();

  Future<void> addData(
      _student_one_name,
      _student_one_github,
      _student_one_reg,
      _student_two_name,
      _student_two_github,
      _student_two_reg,
      _supervisor_name,
      _supervisor_github) async {
    if (_selectedValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Select Your Project To Submit'),
      ));
    } else {
      CollectionReference proj =
          FirebaseFirestore.instance.collection('projects');
      proj.doc(_selectedValue).set({
        "status": true,
        "student-one-name": _student_one_name,
        "student-one-github": _student_one_github,
        "student-one-reg": _student_one_reg,
        "student-two-name": _student_two_name,
        "student_two-github": _student_two_github,
        "student-two-reg": _student_two_reg,
        "supervisor-name": _supervisor_name,
        "supervisor-github": _supervisor_github,
      }, SetOptions(merge: true)).then((value) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Your Information is Submitted'),
          ));
          _selectedValue = null;
        });
      }).catchError((Error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Error.toString()),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: _projects,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return SnackBar(content: Text(snapshot.error.toString()));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  List<DropdownMenuItem<String>> projectItems = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DocumentSnapshot snap = snapshot.data.docs[i];
                    if (snap['status'] == false) {
                      if (!projectItems.contains(snap.id.toString())) {
                        projectItems.add(DropdownMenuItem(
                          child:
                              SizedBox(width: 400, child: Text(snap['title'])),
                          value: snap.id.toString(),
                        ));
                      }
                    }
                  }

                  return DropdownButton(
                    hint: Text('Choose Your Project'),
                    value: _selectedValue,
                    items: projectItems,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValue = newValue.toString();
                      });
                    },
                    isExpanded: true,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text("Student 1 Information",
                      style: Constant.boldRegularHeadings),
                  _build_student_one_name(),
                  _build_student_one_github(),
                  _build_student_one_reg(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "Student 2 Information",
                    style: Constant.boldRegularHeadings,
                  ),
                  _build_student_two_name(),
                  _build_student_two_github(),
                  _build_student_two_reg(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    "Supervisor Information",
                    style: Constant.boldRegularHeadings,
                  ),
                  _build_supervisor_name(),
                  _build_supervisor_github(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 400,
                height: 60,
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () => {
                    if (_formkey.currentState!.validate())
                      {
                        addData(
                            _student_one_name,
                            _student_one_github,
                            _student_one_reg,
                            _student_two_name,
                            _student_two_github,
                            _student_two_reg,
                            _supervisor_name,
                            _supervisor_github),
                      }
                    else
                      {print("something wrong")}
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
