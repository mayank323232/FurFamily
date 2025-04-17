import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vet_slot_book_screen.dart';

class Vet {
  final String name;
  final String specialization;
  final String contact;
  final String imagePath; // Changed from imageUrl

  Vet({
    required this.name,
    required this.specialization,
    required this.contact,
    required this.imagePath,
  });
}

class VetListScreen extends StatelessWidget {
  final List<Vet> vets = [
    Vet(
      name: 'Dr. Priya Sharma',
      specialization: 'Canine Specialist',
      contact: '9876543210',
      imagePath: 'assets/images/vets/vet1.jpg',
    ),
    Vet(
      name: 'Dr. Aman Verma',
      specialization: 'Veterinary Surgeon',
      contact: '9123456789',
      imagePath: 'assets/images/vets/vet2.jpg',
    ),
    Vet(
      name: 'Dr. Sneha Rao',
      specialization: 'Animal Nutritionist',
      contact: '9988776655',
      imagePath: 'assets/images/vets/vet3.jpg',
    ),
    Vet(
      name: 'Dr. Rahul Das',
      specialization: 'Exotic Pets Expert',
      contact: '9080706050',
      imagePath: 'assets/images/vets/vet4.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Available Vets",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5A3E36),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: vets.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final vet = vets[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundImage: AssetImage(vet.imagePath),
                radius: 30,
              ),
              title: Text(
                vet.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vet.specialization,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Contact: ${vet.contact}",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VetSlotBookingScreen(
                        vetName: vet.name,
                        vetSpeciality: vet.specialization,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A3E36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Book",
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
