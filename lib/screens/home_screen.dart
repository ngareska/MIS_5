import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mis_lab3/model/exam.dart';
import 'package:mis_lab3/model/location.dart';
import 'package:mis_lab3/screens/calendar_screen.dart';
import 'package:mis_lab3/screens/google_map_screen.dart';
import 'package:mis_lab3/screens/login_screen.dart';
import 'package:mis_lab3/services/notification_service.dart';
import 'package:mis_lab3/widgets/create_new_exam.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "mainScreen";

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final NotificationService service;

  @override
  void initState() {
    service = NotificationService();
    service.initialize();
    super.initState();
  }

  final List<Exam> _exams = [
    Exam(
        id: "s1",
        name: "Mobile information systems",
        date: DateTime.parse(
          "2023-10-12 10:00:00",
        ),
        location: Location(latitude: 42.0043165, longitude: 21.4096452)),
    Exam(
        id: "s2",
        name: "Databases",
        date: DateTime.parse(
          "2023-08-31 15:00:00",
        ),
        location: Location(latitude: 42.004400, longitude: 21.408918)),
    Exam(
        id: "s3",
        name: "Design of human-computer interaction",
        date: DateTime.parse(
          "2023-02-30 12:00:00",
        ),
        location: Location(latitude: 42.004906, longitude: 21.409890))
  ];

  void _showModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: createNewExam(_addNewExam),
          );
        });
  }

  void _addNewExam(Exam exam) {
    setState(() {
      _exams.add(exam);
    });
  }

  void _deleteExam(String id) {
    setState(() {
      _exams.removeWhere((elem) => elem.id == id);
    });
  }

  String _modifyDate(DateTime date, Location location) {
    String subjectLocation = '';

    if (location.latitude == 42.0043165 && location.longitude == 21.4096452) {
      subjectLocation = "FINKI";
    } else if (location.latitude == 42.004400 &&
        location.longitude == 21.408918) {
      subjectLocation = "FEIT";
    } else {
      subjectLocation = "TMF";
    }
    String dateToString = DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    List<String> dateParts = dateToString.split(" ");
    String modifiedTime = dateParts[1].substring(0, 5);

    return dateParts[0] + ' | ' + modifiedTime + 'h | ' + subjectLocation;
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        print("User has successfully logged out");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LogInScreen()));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR");
      print(e.message);
    }
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Upcoming exams"),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_box_outlined),
          onPressed: () => _showModal(context),
        ),
        ElevatedButton(
          child: const Text("Log out"),
          onPressed: _logOut,
        )
      ],
    );
  }

  Widget _createBody(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: _exams.isEmpty
                ? const Text("No exams scheduled")
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _exams.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 10),
                        child: ListTile(
                          tileColor: Colors.pink[100],
                          title: Text(
                            _exams[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _modifyDate(
                                _exams[index].date, _exams[index].location),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                              onPressed: () => _deleteExam(_exams[index].id),
                              icon: const Icon(Icons.delete_outline)),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    label: const Text(
                      "Calendar",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarScreen(_exams),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.map_outlined,
                      size: 30,
                    ),
                    label: const Text(
                      "Show Map",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoogleMapScreen(_exams),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            label: const Text(
              "Show Local Notification",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              await service.showNotification(
                  id: 0,
                  title: 'You have upcoming exams',
                  body: 'Check your calendar');
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.notifications_paused_sharp,
              size: 30,
            ),
            label: const Text(
              "Schedule Notification",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              await service.showScheduledNotification(
                  id: 0,
                  title: 'You have upcoming exams',
                  body: 'Check your calendar',
                  seconds: 4);
            },
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(context),
    );
  }
}
