import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'EditUserProfileScreen.dart'; // make sure this exists

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "Alex Johnson";
  String email = "alexjohnson@gmail.com";
  String phone = "+91 9876543210";
  String preferredPet = "Dog";
  String address = "123, Chill Street, Noida, India";

  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5A3E36),
        title: Text("My Profile", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : AssetImage('assets/images/user_placeholder.jpg') as ImageProvider,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: Icon(Icons.edit, size: 18, color: Color(0xFF5A3E36)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(userName, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36))),
            SizedBox(height: 8),
            Text(email, style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 4),
            Text(phone, style: GoogleFonts.poppins(fontSize: 16)),
            Divider(height: 32),
            _buildInfoTile("Preferred Pet", preferredPet),
            _buildInfoTile("Address", address),
            Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5A3E36),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserProfileScreen(
                      name: userName,
                      email: email,
                      phone: phone,
                      pet: preferredPet,
                      address: address,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    userName = result['name'];
                    email = result['email'];
                    phone = result['phone'];
                    preferredPet = result['pet'];
                    address = result['address'];
                  });
                }
              },
              icon: Icon(Icons.edit),
              label: Text("Edit Profile", style: GoogleFonts.poppins()),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFF5A3E36))),
          Expanded(child: Text(value, style: GoogleFonts.poppins())),
        ],
      ),
    );
  }
}
