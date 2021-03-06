import 'package:flutter/material.dart';
import 'package:iit_app/data/workshop.dart';
import 'dart:async';
import 'package:iit_app/services/crud.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State {
  final _formKey = GlobalKey<FormState>();
  final _workshop = Workshop();

  CrudMethods crudObj = new CrudMethods();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022));

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _workshop.date = convertDate(picked);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        _workshop.time = converTime(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Workshop')),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: ListView(children: [
                      DropdownButton<String>(
                        items:
                            Workshop.councils.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _workshop.council = value;
                            _workshop.club = null;
                          });
                        },
                        value: _workshop.council,
                        hint: Text('Select Council'),
                      ),
                      DropdownButton<String>(
                        items: Workshop.clubs[_workshop.council]
                            .map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _workshop.club = value;
                          });
                        },
                        value: _workshop.club,
                        hint: Text('Select Club'),
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Title of the Workshop'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                        onSaved: (val) => setState(() => _workshop.title = val),
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please describe the workshop in detail.';
                            }
                            return null;
                          },
                          onSaved: (val) =>
                              setState(() => _workshop.description = val)),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: SwitchListTile(
                            title: const Text('\'number of people going\''),
                            value: _workshop.showGoing,
                            onChanged: (bool val) =>
                                setState(() => _workshop.showGoing = val)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Container(
                          //   padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                          //   child: Text("Select Date:"),
                          // ),
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('${_workshop.date}'),
                          ),
                          RaisedButton(
                            onPressed: () => _selectTime(context),
                            child: Text('${_workshop.time}'),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: RaisedButton(
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  if (_workshop.council == null)
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content:
                                            Text('Please select council')));
                                  else if (_workshop.club == null)
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Please select club')));
                                  else {
                                    form.save();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Submitting form')));
                                    crudObj
                                        .addData(_workshop.createMap())
                                        .then((result) {
                                      Navigator.pop(context);
                                    }).catchError((e) {
                                      print(e);
                                    });
                                  }
                                }
                              },
                              child: Text('Create'))),
                    ])))));
  }
}
