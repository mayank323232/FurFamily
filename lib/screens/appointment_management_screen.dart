import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentManagementScreen extends StatefulWidget {
  final Map<String, String> appointment;
  final int index;
  final void Function(int) onCancel;
  final void Function(int, String, String, String) onEdit;

  AppointmentManagementScreen({
    required this.appointment,
    required this.index,
    required this.onCancel,
    required this.onEdit,
  });

  @override
  _AppointmentManagementScreenState createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState extends State<AppointmentManagementScreen> {
  late String _newName;
  late String _newTime;
  late String _newDate;

  @override
  void initState() {
    super.initState();
    _newName = widget.appointment['name']!;
    _newTime = widget.appointment['time']!;
    _newDate = widget.appointment['date']!;
  }

  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;

  // List of time slots
  List<String> availableTimeSlots = ["10:00 AM", "11:30 AM", "1:00 PM", "2:30 PM", "4:00 PM"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Appointment"),
        backgroundColor: Color(0xFF5A3E36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _newDate = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
                });
              },
            ),
            SizedBox(height: 16),
            Text("Selected Date: $_newDate"),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedTimeSlot,
              hint: Text("Select Time Slot"),
              onChanged: (newValue) {
                setState(() {
                  _selectedTimeSlot = newValue;
                  _newTime = newValue!;
                });
              },
              items: availableTimeSlots.map((timeSlot) {
                return DropdownMenuItem<String>(
                  value: timeSlot,
                  child: Text(timeSlot),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onEdit(widget.index, _newName, _newTime, _newDate);
                    Navigator.pop(context, true); // Return true to indicate changes
                  },
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5A3E36)),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onCancel(widget.index);
                    Navigator.pop(context, true); // Return true to indicate deletion
                  },
                  child: Text("Cancel Appointment"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
