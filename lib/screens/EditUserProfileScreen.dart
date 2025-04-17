import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String pet;
  final String address;

  EditUserProfileScreen({
    required this.name,
    required this.email,
    required this.phone,
    required this.pet,
    required this.address,
  });

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController petController;
  late TextEditingController addressController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    petController = TextEditingController(text: widget.pet);
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    petController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFFFBEED7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
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
        title: Text("Edit Profile", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : AssetImage('assets/images/user_placeholder.jpg') as ImageProvider,
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: _showImagePickerOptions,
                  tooltip: 'Edit Profile Picture',
                ),
              ],
            ),
            SizedBox(height: 20),

            _buildTextField("Name", nameController),
            _buildTextField("Email", emailController),
            _buildTextField("Phone", phoneController),
            _buildTextField("Preferred Pet", petController),
            _buildTextField("Address", addressController, maxLines: 2),

            SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5A3E36),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  "name": nameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "pet": petController.text,
                  "address": addressController.text,
                  // Optional: If you want to pass back the image path too
                  "profilePicPath": _imageFile?.path,
                });
              },
              icon: Icon(Icons.save),
              label: Text("Save Changes", style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
