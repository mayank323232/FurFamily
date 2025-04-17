import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_new_pet_screen.dart'; // Import the AddNewPetScreen

class ManagePetScreen extends StatefulWidget {
  @override
  _ManagePetScreenState createState() => _ManagePetScreenState();
}

class _ManagePetScreenState extends State<ManagePetScreen> {
  // Sample Pet Data (Replace with backend data when available)
  List<Map<String, String>> pets = [
    {
      "name": "Dharampal",
      "breed": "Desi Dog (Street Smart)",
      "age": "4 years",
      "gender": "Male",
      "description": "Knows every gali ka shortcut. A true Indian roadie 🛵🐾.",
      "image": "assets/images/dog1.jpg", // Placeholder Image
    },
    {
      "name": "Chintu",
      "breed": "Indian Spitz",
      "age": "2 years",
      "gender": "Male",
      "description": "Thinks he's a lion, scared of cucumbers 🥒🦁.",
      "image": "assets/images/dog2.jpg", // Placeholder Image
    },
    {
      "name": "Gulabo",
      "breed": "Persian Cat",
      "age": "3 years",
      "gender": "Female",
      "description": "Judges everyone from her throne. Royal AF 👑🐱.",
      "image": "assets/images/cat2.jpg", // Placeholder Image
    },
    {
      "name": "Sundari",
      "breed": "Golden Retriever",
      "age": "5 years",
      "gender": "Female",
      "description": "Loves kids and laddoos. Will trade belly rubs for treats 🎾🍬.",
      "image": "assets/images/dog5.jpg", // Placeholder Image
    },
    {
      "name": "Sheru",
      "breed": "German Shepherd",
      "age": "6 years",
      "gender": "Male",
      "description": "Guard dog vibes but scared of loud crackers 💥🐶.",
      "image": "assets/images/dog9.jpg", // Placeholder Image
    },
    {
      "name": "Babli",
      "breed": "Mixed Breed",
      "age": "1.5 years",
      "gender": "Female",
      "description": "Small package, big attitude. The real boss lady 💅🔥.",
      "image": "assets/images/cat5.jpg", // Placeholder Image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Pets",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display pet image
                  Image.asset(
                    pet['image'] ?? 'assets/default.jpg', // Default Image if none exists
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    pet['name'] ?? 'No Name',  // Provide a fallback for null
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A3E36),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text("Breed: ${pet['breed'] ?? 'Unknown'}"), // Provide a fallback for null
                  Text("Age: ${pet['age'] ?? 'Unknown'}"), // Provide a fallback for null
                  Text("Gender: ${pet['gender'] ?? 'Unknown'}"), // Provide a fallback for null
                  SizedBox(height: 8),
                  Text(
                    pet['description'] ?? 'No description available', // Provide a fallback for null
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          _showEditDialog(context, pet, index);
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          _showDeleteDialog(context, pet, index);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to AddNewPetScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewPetScreen()),
          );
        },
        backgroundColor: Color(0xFF5A3E36),
        icon: Icon(Icons.add),
        label: Text(
          "Add Pet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Edit Dialog
  void _showEditDialog(BuildContext context, Map<String, String> pet, int index) {
    TextEditingController nameController = TextEditingController(text: pet['name']);
    TextEditingController breedController = TextEditingController(text: pet['breed']);
    TextEditingController ageController = TextEditingController(text: pet['age']);
    TextEditingController descriptionController = TextEditingController(text: pet['description']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Pet Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: breedController,
                decoration: InputDecoration(labelText: 'Breed'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the pet data in the local state (in-memory)
                setState(() {
                  pets[index] = {
                    "name": nameController.text ?? 'No Name', // Fallback for null
                    "breed": breedController.text ?? 'Unknown', // Fallback for null
                    "age": ageController.text ?? 'Unknown', // Fallback for null
                    "gender": pet['gender'] ?? 'Unknown', // Keep original gender
                    "description": descriptionController.text ?? 'No description available', // Fallback for null
                    "image": pet['image'] ?? 'assets/default.jpg', // Keep original image
                  };
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pet details updated!')),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Delete Dialog
  void _showDeleteDialog(BuildContext context, Map<String, String> pet, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete ${pet['name']}?'),
          content: Text('Are you sure you want to delete this pet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the pet from the list
                setState(() {
                  pets.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${pet['name']} deleted!')),
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
