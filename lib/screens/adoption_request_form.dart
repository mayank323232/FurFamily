import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdoptionRequestForm extends StatefulWidget {
  final bool isEditable; // New: Check if the form is in edit mode

  AdoptionRequestForm({this.isEditable = false});

  @override
  _AdoptionRequestFormState createState() => _AdoptionRequestFormState();
}

class _AdoptionRequestFormState extends State<AdoptionRequestForm> {
  final _formKey = GlobalKey<FormState>();

  // User Input Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController otherPetsController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // Shelter Editable Fields (Stored Settings)
  TextEditingController criteriaController = TextEditingController(text: "Must have a pet-friendly home");
  TextEditingController documentsController = TextEditingController(text: "Government ID, Address Proof");
  TextEditingController notesController = TextEditingController(text: "Home visits may be required");

  bool hasPetExperience = false;
  bool hasOtherPets = false;
  String houseType = "Own";
  String preferredPet = "Dog";
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(widget.isEditable ? 'Edit Adoption Form' : 'Adoption Request Form',
            style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Color(0xFF5A3E36),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Editable by Shelter Owners
                if (widget.isEditable) ...[
                  _buildTextField(criteriaController, "Adoption Criteria", isEditable: widget.isEditable),
                  _buildTextField(documentsController, "Required Documents", isEditable: widget.isEditable),
                  _buildTextField(notesController, "Additional Notes", isEditable: widget.isEditable),
                  SizedBox(height: 20),
                ],

                // 🔹 User Input Fields (Only Users Can Fill These)
                if (!widget.isEditable) ...[
                  _buildTextField(nameController, "Full Name"),
                  _buildTextField(ageController, "Age", keyboardType: TextInputType.number),
                  _buildTextField(emailController, "Email", keyboardType: TextInputType.emailAddress),
                  _buildTextField(phoneController, "Phone Number", keyboardType: TextInputType.phone),
                  _buildTextField(addressController, "Address", maxLines: 3),

                  SizedBox(height: 10),
                  _buildSwitch("Do you have experience with pets?", hasPetExperience, (val) {
                    setState(() => hasPetExperience = val);
                  }),

                  SizedBox(height: 10),
                  _buildDropdown("Type of House", ["Own", "Rent"], houseType, (value) {
                    setState(() => houseType = value!);
                  }),

                  SizedBox(height: 10),
                  _buildSwitch("Do you have any other pets?", hasOtherPets, (val) {
                    setState(() => hasOtherPets = val);
                  }),
                  if (hasOtherPets)
                    _buildTextField(otherPetsController, "If Yes, which ones?"),

                  _buildDropdown("Preferred Pet Type", ["Dog", "Cat", "Other"], preferredPet, (value) {
                    setState(() => preferredPet = value!);
                  }),

                  _buildTextField(reasonController, "Why do you want to adopt?", maxLines: 3),

                  SizedBox(height: 10),
                  CheckboxListTile(
                    value: agreedToTerms,
                    activeColor: Color(0xFF5A3E36),
                    onChanged: (value) => setState(() => agreedToTerms = value!),
                    title: Text(
                      "I agree to provide proper care, food, and vet checkups.",
                      style: GoogleFonts.poppins(),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  SizedBox(height: 20),
                ],

                // 🔹 Submit or Save Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Text Field Builder (Now Supports Editable Mode)
  Widget _buildTextField(TextEditingController controller, String label, {bool isEditable = false, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: isEditable || !widget.isEditable, // Shelter owners can edit their part
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔹 Switch Builder
  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF5A3E36))),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF5A3E36),
        ),
      ],
    );
  }

  // 🔹 Dropdown Builder
  Widget _buildDropdown(String title, List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF5A3E36))),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Submit or Save Button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF5A3E36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (widget.isEditable) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Form Updated Successfully!"),
              backgroundColor: Colors.green,
            ));
          } else if (_formKey.currentState!.validate() && agreedToTerms) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Adoption Request Submitted!"),
              backgroundColor: Colors.green,
            ));
          }
        },
        child: Text(widget.isEditable ? "Save Changes" : "Submit Request"),
      ),
    );
  }
}
