import 'dart:io'; // Import for File handling
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Import for Image Picker
import 'package:fur_family/screens/manage_pet_screen.dart';
import 'package:fur_family/screens/terms_and_conditions.dart';
import 'package:fur_family/screens/donation_screen.dart';

class NgoProfileScreen extends StatefulWidget {
  @override
  _NgoProfileScreenState createState() => _NgoProfileScreenState();
}

class _NgoProfileScreenState extends State<NgoProfileScreen> {
  File? _image; // This will store the selected image
  String ngoName = "Hope Animal Shelter";
  String ownerName = "John Doe";
  String location = "Mumbai, India";
  String phone = "+91 9876543210";
  String email = "hopeanimals@gmail.com";
  String about = "We rescue and care for stray animals and help them find loving homes. Join us in making a difference!";

  // Function to pick an image from the gallery or take a photo
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take a photo"),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path); // Update image
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Choose from gallery"),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path); // Update image
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        backgroundColor: Color(0xFF5A3E36),
        title: Text(
          'NGO Profile',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // NGO Logo + Edit Profile Icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _pickImage, // Pick image on tap
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: _image != null
                        ? FileImage(_image!) // Use the selected image
                        : AssetImage('assets/images/logo.jpg') as ImageProvider, // Default image if no selection
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage, // Also allow tapping to change image
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Icon(Icons.edit, color: Color(0xFF5A3E36), size: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Editable NGO Name
            _buildEditableField("NGO Name", ngoName, (value) {
              setState(() {
                ngoName = value;
              });
            }),

            // Editable Owner Name
            _buildEditableField("Owner Name", ownerName, (value) {
              setState(() {
                ownerName = value;
              });
            }),

            // Editable Contact Info
            _buildEditableField("Location", location, (value) {
              setState(() {
                location = value;
              });
            }),
            _buildEditableField("Phone", phone, (value) {
              setState(() {
                phone = value;
              });
            }),
            _buildEditableField("Email", email, (value) {
              setState(() {
                email = value;
              });
            }),

            SizedBox(height: 15),

            // Editable About Us Section
            _buildEditableField("About Us", about, (value) {
              setState(() {
                about = value;
              });
            }),
            SizedBox(height: 25),

            // Quick Stats
            _buildSectionTitle("Quick Stats"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Pets Listed", "15"),
                _buildStatCard("Adoptions", "10"),
                _buildStatCard("Pending", "3"),
              ],
            ),
            SizedBox(height: 30),

            // Action Buttons
            _buildActionButton(context, "Manage Pets", Icons.pets, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePetScreen()));
            }),
            _buildActionButton(context, "Support Us / Donations", Icons.volunteer_activism, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonationsScreen()));
            }),
            _buildActionButton(context, "Terms & Conditions", Icons.policy, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditions()));
            }),
            SizedBox(height: 30),

            // Logout Button with Confirmation Dialog
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFFBEED7),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      title: Text(
                        'Logout',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('No', style: GoogleFonts.poppins(color: Colors.redAccent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Yes', style: GoogleFonts.poppins(color: Colors.green)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text("Logout", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget to make the field editable
  Widget _buildEditableField(String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF7A5C4F)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: onChanged,
      ),
    );
  }

  // Widget for Section Title
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
      ),
    );
  }

  // Widget for Stats Cards
  Widget _buildStatCard(String label, String count) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(count, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36))),
          SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF7A5C4F))),
        ],
      ),
    );
  }

  // Widget for Action Button
  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5A3E36),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
