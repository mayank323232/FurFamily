import 'package:flutter/material.dart';
import 'package:fur_family/screens/pet_listings_screen.dart';
import 'package:fur_family/screens/ngo_profile_screen.dart';
import 'package:fur_family/screens/adoption_requests_screen.dart';
import 'package:fur_family/screens/add_new_pet_screen.dart';
import 'package:fur_family/screens/manage_pet_screen.dart'; // 💡 Make sure you have this file
import 'package:fur_family/screens/pet_medical_records_screen.dart';

import 'package:google_fonts/google_fonts.dart';

class NgoHomeScreen extends StatefulWidget {
  final bool isOwner;

  NgoHomeScreen({required this.isOwner});

  @override
  _NgoHomeScreenState createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddNewPetScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NgoProfileScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdoptionRequestsScreen()),
      );
    } else if (index == 3) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetMedicalRecordsScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NGO & Shelter Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClickableSection(
                  "Manage Adoptable Pets", ManagePetScreen(), 'assets/images/pet_placeholder.jpg'),
              SizedBox(height: 20),

              _buildClickableSection("Adoption Requests", AdoptionRequestsScreen(),
                  'assets/images/adoption_placeholder.jpg'),
              SizedBox(height: 20),

              _buildClickableSection("Pet Medical Records", PetMedicalRecordsScreen(),
                  'assets/images/medical_placeholder.jpg'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF5A3E36),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Add Pet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
        ],
      ),
    );
  }

  Widget _buildClickableSection(String title, Widget screen, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            shadowColor: Color(0x55000000),
            child: Container(
              height: 100,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "$title (Click to Manage)",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF5A3E36),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5A3E36),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5A3E36),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          '$title (Coming Soon)',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
