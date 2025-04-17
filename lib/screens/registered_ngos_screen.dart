import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fur_family/screens/public_ngo_profile_screen.dart';

class RegisteredNGOsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> ngos = [
    {
      'name': 'Stray Savers',
      'logoAsset': 'assets/images/stray_savers.png',
      'contactInfo': 'straysavers@gmail.com\n+91 9876543210',
      'about':
      'We rescue, care for, and rehome stray animals across the city. Join us in making a difference!',
      'totalPets': 40,
      'adoptionsCompleted': 22,
      'donationsReceived': 88,
    },
    {
      'name': 'Paw Protectors',
      'logoAsset': 'assets/images/paw_protecters.jpg',
      'contactInfo': 'pawprotectors@ngo.org\n+91 9123456780',
      'about':
      'Providing shelter and medical aid to abandoned pets since 2012.',
      'totalPets': 65,
      'adoptionsCompleted': 45,
      'donationsReceived': 132,
    },
    {
      'name': 'TailWaggers Shelter',
      'logoAsset': 'assets/images/tailwaggers.jpg',
      'contactInfo': 'tailwaggers@care.org\n+91 9988776655',
      'about': 'A no-kill shelter with a mission to rehome every animal. ❤️',
      'totalPets': 28,
      'adoptionsCompleted': 20,
      'donationsReceived': 59,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Registered NGOs",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5A3E36),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: ngos.length,
        itemBuilder: (context, index) {
          final ngo = ngos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PublicNGOProfileScreen(
                    ngoName: ngo['name'],
                    logoAsset: ngo['logoAsset'], // ✅ using asset image path
                    contactInfo: ngo['contactInfo'],
                    about: ngo['about'],
                    totalPets: ngo['totalPets'],
                    adoptionsCompleted: ngo['adoptionsCompleted'],
                    donationsReceived: ngo['donationsReceived'],
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(ngo['logoAsset']),
                  radius: 30,
                ),
                title: Text(
                  ngo['name'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  ngo['contactInfo'].split('\n')[0],
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          );
        },
      ),
    );
  }
}
