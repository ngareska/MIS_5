import 'package:flutter/cupertino.dart';
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
  final _timeController = TextEditingController();

  void _submitData() {
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      return;
    }

    final newExam = Exam(
      id: nanoid(5),
      name: _nameController.text,
      date: _dateController.text,
      time: _timeController.text,
    );
    widget.addExam(newExam);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(13),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Subject name"),
              controller: _nameController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Date"),
              controller: _dateController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Time"),
              controller: _timeController,
              onSubmitted: (_) => _submitData(),
            ),
          ],
        ));
  }
}
