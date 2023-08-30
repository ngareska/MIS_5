import 'package:flutter/material.dart';
import 'package:mis_lab3/model/exam.dart';
import 'package:mis_lab3/widgets/create_new_exam.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Exam> _exams = [
    Exam(
        id: "s1",
        name: "Mobile information systems",
        date: "10.30.2023",
        time: "11:00h"),
    Exam(id: "s2", name: "Databases", date: "22.08.2023", time: "11:30h"),
    Exam(
        id: "s3",
        name: "Design of human-computer interaction",
        date: "19.10.2023",
        time: "12:00h"),
  ];

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: createNewExam(_addNewExamToList),
              behavior: HitTestBehavior.opaque);
        });
  }

  void _addNewExamToList(Exam item) {
    setState(() {
      _exams.add(item);
    });
  }

  void _deleteExam(String id) {
    setState(() {
      _exams.removeWhere((elem) => elem.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lab3_193102"),
        actions: <Widget>[
          IconButton(
            onPressed: () => _addItemFunction(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: _exams.isEmpty
            ? Text("No exams!")
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      title: Text(
                        _exams[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _exams[index].date + "  " + _exams[index].time,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteExam(_exams[index].id),
                      ),
                    ),
                  );
                },
                itemCount: _exams.length,
              ),
      ),
    );
  }
}
