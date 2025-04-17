import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'appointment_management_screen.dart';
import 'pet_records_screen.dart';
import 'vet_profile_screen.dart';

class VetHomeScreen extends StatefulWidget {
  final String vetName;

  const VetHomeScreen({required this.vetName, Key? key}) : super(key: key);

  @override
  _VetHomeScreenState createState() => _VetHomeScreenState();
}

class _VetHomeScreenState extends State<VetHomeScreen> {
  int _selectedIndex = 0;

  List<Map<String, String>> appointments = [
    {'name': "John Doe", 'time': "10:00 AM", 'date': "2025-04-16"},
    {'name': "Jane Smith", 'time': "11:30 AM", 'date': "2025-04-16"},
    {'name': "Jack White", 'time': "2:00 PM", 'date': "2025-04-16"},
    {'name': "Tommy Bhai", 'time': "3:00 PM", 'date': "2025-04-16"},
    {'name': "Bubbly Aunty", 'time': "4:15 PM", 'date': "2025-04-16"},
    {'name': "Sharma Ji", 'time': "5:30 PM", 'date': "2025-04-16"},
  ];

  void _updateAppointment(int index, String newName, String newTime, String newDate) {
    setState(() {
      appointments[index] = {
        'name': newName,
        'time': newTime,
        'date': newDate,
      };
    });
  }

  void _cancelAppointment(int index) {
    setState(() {
      appointments.removeAt(index);
    });
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      VetDashboardHomeScreen(
        appointments: appointments,
        onCancel: _cancelAppointment,
        onEdit: _updateAppointment,
        vetName: widget.vetName,
      ),
      PetRecordsScreen(),
      VetProfileScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Color(0xFF5A3E36),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pet Records"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class VetDashboardHomeScreen extends StatefulWidget {
  final List<Map<String, String>> appointments;
  final void Function(int) onCancel;
  final void Function(int, String, String, String) onEdit;
  final String vetName;

  const VetDashboardHomeScreen({
    required this.appointments,
    required this.onCancel,
    required this.onEdit,
    required this.vetName,
  });

  @override
  _VetDashboardHomeScreenState createState() => _VetDashboardHomeScreenState();
}

class _VetDashboardHomeScreenState extends State<VetDashboardHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, ${widget.vetName}!", // Display the vet's name here
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
          ),
          SizedBox(height: 20),
          Text(
            "Appointments",
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.appointments.length,
              itemBuilder: (context, index) {
                final appointment = widget.appointments[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      appointment['name'] ?? '',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${appointment['date']} at ${appointment['time']}",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                    ),
                    leading: Icon(Icons.calendar_today, color: Color(0xFF5A3E36)),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Color(0xFF5A3E36)),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentManagementScreen(
                              appointment: appointment,
                              index: index,
                              onCancel: widget.onCancel,
                              onEdit: widget.onEdit,
                            ),
                          ),
                        );
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
  _AppointmentManagementScreenState createState() => _AppointmentManagementScreenState();
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
                    Navigator.pop(context, true);
                  },
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5A3E36)),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onCancel(widget.index);
                    Navigator.pop(context, true);
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
