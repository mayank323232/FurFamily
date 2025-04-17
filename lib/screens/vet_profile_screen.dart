import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vet_home_screen.dart';
import 'login_screen.dart'; // Make sure this file exists

class VetProfileScreen extends StatefulWidget {
  @override
  _VetProfileScreenState createState() => _VetProfileScreenState();
}

class _VetProfileScreenState extends State<VetProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController specializationController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    nameController.text = 'Dr. Sharma';
    contactController.text = '+91 1234567890';
    specializationController.text = 'Veterinary Surgeon';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<File>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick an image'),
          actions: [
            TextButton(
              onPressed: () async {
                final picked = await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, picked?.path != null ? File(picked!.path) : null);
              },
              child: Text('From Gallery'),
            ),
            TextButton(
              onPressed: () async {
                final picked = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, picked?.path != null ? File(picked!.path) : null);
              },
              child: Text('From Camera'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _saveProfile() {
    String vetName = nameController.text;
    String vetContact = contactController.text;
    String vetSpecialization = specializationController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VetHomeScreen(
          vetName: vetName,
        ),
      ),
    );
  }

  void _logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text("Vet Profile",
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF5A3E36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF5A3E36),
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // Name
            Text("Name:", style: TextStyle(fontSize: 18, color: Color(0xFF5A3E36))),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Contact
            Text("Contact:", style: TextStyle(fontSize: 18, color: Color(0xFF5A3E36))),
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                hintText: "Enter contact number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Specialization
            Text("Specialization:", style: TextStyle(fontSize: 18, color: Color(0xFF5A3E36))),
            TextField(
              controller: specializationController,
              decoration: InputDecoration(
                hintText: "Enter your specialization",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

// Save Button
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: Icon(Icons.save, size: 24),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5A3E36),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                minimumSize: Size(double.infinity, 55),
              ),
            ),
            SizedBox(height: 20),


// Logout Button
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout, size: 24),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0), // thicc padding bro
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                minimumSize: Size(double.infinity, 55), // full width + height bump
              ),
            ),

          ],
        ),
      ),
    );
  }
}
