import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Fur Family!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A3E36),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'By using this app, you agree to follow these terms and conditions. Please read them carefully.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            _buildBulletPoint("You must provide accurate and truthful information when registering."),
            _buildBulletPoint("Pet adoptions are subject to approval by pet owners or shelters."),
            _buildBulletPoint("Any misuse or fraudulent activity will result in account suspension."),
            _buildBulletPoint("You agree to take full responsibility for any pet you adopt through this platform."),
            _buildBulletPoint("We are not responsible for any post-adoption issues or disputes."),
            _buildBulletPoint("Your personal information will be handled securely and will not be shared without consent."),
            SizedBox(height: 24),
            Text(
              'Note:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5A3E36),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'These terms can be updated anytime. Keep checking this page to stay informed.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'If you have any questions, feel free to reach out to us!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•  ",
            style: GoogleFonts.poppins(fontSize: 18, color: Color(0xFF5A3E36)),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
