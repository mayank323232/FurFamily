import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Required for image picking
import 'dart:io'; // For File handling

class AddNewPetScreen extends StatefulWidget {
  @override
  _AddNewPetScreenState createState() => _AddNewPetScreenState();
}

class _AddNewPetScreenState extends State<AddNewPetScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController healthController = TextEditingController();
  final TextEditingController personalityController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String selectedGender = 'Male';
  bool isAvailable = true; // ✅ Bonus: Default pet status

  File? petImage; // For the picked image

  void submitPet() {
    if (_formKey.currentState!.validate()) {
      // 🔥 Data ready to be pushed to backend
      final petData = {
        'name': nameController.text,
        'breed': breedController.text,
        'age': ageController.text,
        'gender': selectedGender,
        'healthInfo': healthController.text,
        'personality': personalityController.text,
        'birthdate': birthdateController.text,
        'isAvailable': isAvailable, // ✅ status will be stored as true/false
        'image': petImage?.path ?? 'No image selected', // Path of the selected image
      };

      // ✅ Temporary confirmation before backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet Added Successfully ✅\nStatus: ${isAvailable ? "Available" : "Not Available"}')),
      );

      print("Pet Data: $petData"); // Debug purpose for now bro!

      // Clear fields after submission
      nameController.clear();
      breedController.clear();
      ageController.clear();
      healthController.clear();
      personalityController.clear();
      birthdateController.clear();
      setState(() {
        selectedGender = 'Male';
        isAvailable = true; // Reset status
        petImage = null; // Clear image
      });
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        petImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Pet",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5A3E36),
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Pet Name", nameController),
                buildTextField("Breed/Type", breedController),
                buildTextField("Age", ageController, isNumber: true),
                buildDropdownField("Gender"),
                buildTextField("Health Info/Vaccination", healthController),
                buildTextField("Personality/Behavior", personalityController),
                buildDateField("Birthdate", birthdateController),
                SizedBox(height: 10),

                // Pet Image Picker
                GestureDetector(
                  onTap: pickImage,
                  child: petImage == null
                      ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF5A3E36).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Color(0xFF5A3E36),
                      size: 60,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      petImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // ✅ Bonus Feature: Available / Not Available toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available for Adoption?",
                      style: GoogleFonts.poppins(fontSize: 18, color: Color(0xFF5A3E36), fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: isAvailable,
                      activeColor: Color(0xFF5A3E36),
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: submitPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A3E36),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text("Add Pet", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: ['Male', 'Female', 'Other'].map((gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender, style: GoogleFonts.poppins()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedGender = value!;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            });
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
