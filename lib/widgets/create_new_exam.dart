import 'package:flutter/material.dart';
import 'package:mis_lab3/model/exam.dart';
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

  void _submitData() {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty) {
      return;
    }

    int check1 = '-'.allMatches(_dateController.text).length;
    int check2 = ':'.allMatches(_dateController.text).length;

    if (_dateController.text.length < 16 || check1 != 2 || check2 != 1) {
      print("Please enter date in the right format!");
      return;
    }

    final String stringDate = '${_dateController.text}:00';
    DateTime date = DateTime.parse(stringDate);

    final newExam = Exam(
      id: nanoid(5),
      name: _nameController.text,
      date: date,
    );
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
              decoration:const InputDecoration(labelText: "Subject name"),
              controller: _nameController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration:const InputDecoration(labelText: "Date"),
              controller: _dateController,
              onSubmitted: (_) => _submitData(),
            ),
          ],
        ));
  }
}
