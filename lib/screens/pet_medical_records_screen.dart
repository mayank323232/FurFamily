import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetMedicalRecordsScreen extends StatelessWidget {
  const PetMedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> medicalRecords = [
      {
        'pet': 'Bholu',
        'record': 'Vaccinated',
        'date': '01-April-2024',
        'notes': 'Rabies and DHPP vaccines administered.',
      },
      {
        'pet': 'Chintu',
        'record': 'Dewormed',
        'date': '10-March-2024',
        'notes': 'General deworming for intestinal parasites.',
      },
      {
        'pet': 'Sheru',
        'record': 'Checkup',
        'date': '25-February-2024',
        'notes': 'Routine health checkup. Fit and healthy.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Pet Medical Records",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5A3E36),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: medicalRecords.isEmpty
            ? Center(
          child: Text(
            'No medical records available.',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        )
            : ListView.separated(
          itemCount: medicalRecords.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final record = medicalRecords[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pets, color: Colors.brown),
                        const SizedBox(width: 8),
                        Text(
                          record['pet'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.medical_services_outlined,
                            color: Colors.redAccent),
                        const SizedBox(width: 8),
                        Text(
                          record['record'],
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.blueGrey),
                        const SizedBox(width: 8),
                        Text(
                          record['date'],
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Notes:",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record['notes'],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
