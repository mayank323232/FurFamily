import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payments_screen.dart';
import 'adoption_form.dart';

class PublicNGOProfileScreen extends StatelessWidget {
  final String ngoName;
  final String logoAsset; // changed from logoUrl
  final String contactInfo;
  final String about;
  final int totalPets;
  final int adoptionsCompleted;
  final int donationsReceived;

  PublicNGOProfileScreen({
    required this.ngoName,
    required this.logoAsset,
    required this.contactInfo,
    required this.about,
    required this.totalPets,
    required this.adoptionsCompleted,
    required this.donationsReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          ngoName,
          style: GoogleFonts.poppins(
            fontSize: 20,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(logoAsset), // 👈 asset image
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              ngoName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A3E36),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              contactInfo,
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("About"),
            Text(
              about,
              style: GoogleFonts.poppins(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Quick Stats"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard("Pets", totalPets),
                _buildStatCard("Adopted", adoptionsCompleted),
                _buildStatCard("Donations", donationsReceived),
              ],
            ),
            const SizedBox(height: 30),
            _buildMainActionButton(
              context,
              "Fill Adoption Form",
              Icons.pets,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdoptionRequestForm(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildMainActionButton(
              context,
              "Donate",
              Icons.volunteer_activism,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentsScreen(ngoName: ngoName),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5A3E36),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 100,
        child: Column(
          children: [
            Text(
              "$value",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A3E36),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onTap,
      ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5A3E36),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
