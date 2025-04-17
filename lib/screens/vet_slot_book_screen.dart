import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fur_family/utils/appointment_manager.dart';

class VetSlotBookingScreen extends StatefulWidget {
  final String vetName;
  final String vetSpeciality;

  VetSlotBookingScreen({required this.vetName, required this.vetSpeciality});

  @override
  _VetSlotBookingScreenState createState() => _VetSlotBookingScreenState();
}

class _VetSlotBookingScreenState extends State<VetSlotBookingScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;
  String _petName = "";

  final List<String> _slots = [
    "10:00 AM - 10:30 AM",
    "11:00 AM - 11:30 AM",
    "12:00 PM - 12:30 PM",
    "2:00 PM - 2:30 PM",
    "4:00 PM - 4:30 PM"
  ];

  void _confirmBooking() {
    if (_selectedDate == null || _selectedSlot == null || _petName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bro… pick date, slot *and* enter pet name 😩")),
      );
      return;
    }

    final formattedDate = _selectedDate!.toLocal().toString().split(' ')[0];

    // 💾 Save appointment using AppointmentManager
    AppointmentManager.addAppointment({
      'vetName': widget.vetName,
      'date': formattedDate,
      'time': _selectedSlot,
      'petName': _petName.trim(),
    });

    // ✅ Confirmation popup
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Appointment Confirmed 🐾", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          "You're all set!\n\nVet: ${widget.vetName}\nDate: $formattedDate\nTime: $_selectedSlot\nPet: $_petName",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: Text("Let's go!", style: GoogleFonts.poppins()),
          )
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5A3E36),
        title: Text("Book Appointment", style: GoogleFonts.poppins(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.vetName, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.vetSpeciality, style: GoogleFonts.poppins(color: Colors.grey[600])),

            SizedBox(height: 30),
            Text("Pet Name", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              onChanged: (val) => _petName = val,
              decoration: InputDecoration(
                hintText: "e.g. Snowball 🐶",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              style: GoogleFonts.poppins(),
            ),

            SizedBox(height: 30),
            Text("Select Date", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  _selectedDate == null
                      ? "Tap to pick a date"
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),

            SizedBox(height: 30),
            Text("Select Time Slot", style: GoogleFonts.poppins(fontSize: 16)),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _slots.map((slot) {
                bool selected = slot == _selectedSlot;
                return ChoiceChip(
                  label: Text(slot, style: GoogleFonts.poppins()),
                  selected: selected,
                  selectedColor: Color(0xFF5A3E36),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                  onSelected: (val) {
                    setState(() {
                      _selectedSlot = val ? slot : null;
                    });
                  },
                );
              }).toList(),
            ),

            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5A3E36),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Book Now", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
