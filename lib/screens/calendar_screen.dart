import 'package:flutter/material.dart';
import 'package:mis_lab3/model/exam.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarScreen extends StatelessWidget{
  static const String idScreen = "calendarScreen";
  final List<Exam> _exams;

  const CalendarScreen(this._exams);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text ("Calendar"),
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource(_exams)),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
          ),
          firstDayOfWeek: 1,
          showDatePickerButton: true,
        ),
      )
    );
  }
}

List<Exam> _getDataSource(List<Exam> exams) {
  final List<Exam> scheduledExams = exams;
  return scheduledExams;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Exam> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].date;
  }
  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

}