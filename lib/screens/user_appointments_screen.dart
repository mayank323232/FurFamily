import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fur_family/utils/appointment_manager.dart';

class UserAppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appointments = AppointmentManager.getAppointments();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Vet Appointments",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Color(0xFF5A3E36),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: appointments.isEmpty
          ? Center(
        child: Text(
          "No appointments yet 😿",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: Color(0xFF5A3E36)),
              title: Text(
                appointment['vetName'],
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Date: ${appointment['date']}\nTime: ${appointment['time']}\nPet: ${appointment['petName']}",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
