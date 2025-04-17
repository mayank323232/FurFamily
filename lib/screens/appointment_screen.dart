import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/appointment.dart';

class AppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text("My Appointments", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
      ),
      body: globalAppointments.isEmpty
          ? Center(
        child: Text(
          "No appointments yet, go book one 🐶",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: globalAppointments.length,
        itemBuilder: (context, index) {
          final appt = globalAppointments[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(appt.vetName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appt.vetSpeciality, style: GoogleFonts.poppins()),
                  Text("Date: ${appt.date.toLocal().toString().split(' ')[0]}", style: GoogleFonts.poppins()),
                  Text("Slot: ${appt.slot}", style: GoogleFonts.poppins()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
