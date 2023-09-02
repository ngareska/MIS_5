import 'package:flutter/material.dart';
import 'package:mis_lab3/model/exam.dart';
import 'package:mis_lab3/model/location.dart';
import 'package:nanoid/nanoid.dart';

class createNewExam extends StatefulWidget {
  final Function addExam;
  createNewExam(this.addExam);

  @override
  State<StatefulWidget> createState() => _createNewExamState();
}

class _createNewExamState extends State<createNewExam> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  String dropdownValue = 'FINKI';
  late Location location;

  Future? _submitData(BuildContext context) {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Please fill in all the fields!'),
          actions: <Widget>[
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text("OK"),
                ))
          ],
        ),
      );
    }
    int check1 = '-'.allMatches(_dateController.text).length;
    int check2 = ':'.allMatches(_dateController.text).length;

    if (_dateController.text.length < 16 || check1 != 2 || check2 != 1) {
      print("Please enter date in the right format!");
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid date format!'),
          content: SingleChildScrollView(
            child: const Text("Please enter date in the right format."),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text("OK"),
                ))
          ],
        ),
      );
    }

    final String stringDate = '${_dateController.text}:00';
    DateTime date = DateTime.parse(stringDate);

    if (dropdownValue == "FINKI") {
      location = Location(latitude: 42.0043165, longitude: 21.4096452);
    } else if (dropdownValue == "FEIT") {
      location = Location(latitude: 42.004400, longitude: 21.408918);
    } else {
      location = Location(latitude: 42.004906, longitude: 21.409890);
    }
    final newExam = Exam(
        id: nanoid(5),
        name: _nameController.text,
        date: date,
        location: location);
    widget.addExam(newExam);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Subject name"),
            controller: _nameController,
            textInputAction: TextInputAction.next,
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Date"),
            controller: _dateController,
            textInputAction: TextInputAction.next,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  "Location",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
              ),
              DropdownButton(
                  value: dropdownValue,
                  items: <String>['FINKI', 'TMF', 'FEIT']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                    print("submitted");
                    _submitData(context);
                  })
            ],
          )
        ],
      ),
    );
  }
}
