import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetRecordsScreen extends StatefulWidget {
  @override
  _PetRecordsScreenState createState() => _PetRecordsScreenState();
}

class _PetRecordsScreenState extends State<PetRecordsScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> allPetRecords = []; // Full pet list (from database)
  List<Map<String, String>> filteredPetRecords = []; // Search results

  @override
  void initState() {
    super.initState();
    _fetchPetRecords(); // Load data when screen opens
  }

  // Simulated database fetch (Replace this with actual backend call)
  Future<void> _fetchPetRecords() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating network delay

    List<Map<String, String>> records = [
      {"name": "Sheru", "breed": "Labrador", "owner": "Ravi", "age": "3", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/dog1.jpg", "type": "dog"},
      {"name": "Tommy", "breed": "Beagle", "owner": "Priya", "age": "2", "vaccinated": "No", "treatment": "Minor skin allergy", "image": "assets/images/dog2.jpg", "type": "dog"},
      {"name": "Moti", "breed": "Indian Pariah Dog", "owner": "Ankit", "age": "4", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/dog3.jpg", "type": "dog"},
      {"name": "Simba", "breed": "Rottweiler", "owner": "Neha", "age": "3", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/dog4.jpg", "type": "dog"},
      {"name": "Bobby", "breed": "Pitbull", "owner": "Raj", "age": "3", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/dog5.jpg", "type": "dog"},
      {"name": "Mia", "breed": "Persian Cat", "owner": "Leela", "age": "2", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/cat1.jpg", "type": "cat"},
      {"name": "Whiskers", "breed": "Siamese Cat", "owner": "Asha", "age": "3", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/cat2.jpg", "type": "cat"},
      {"name": "Chintu", "breed": "Indian Cat", "owner": "Suresh", "age": "1", "vaccinated": "No", "treatment": "Ear infection", "image": "assets/images/cat3.jpg", "type": "cat"},
      {"name": "Ziggy", "breed": "Bengal Cat", "owner": "Ritu", "age": "4", "vaccinated": "Yes", "treatment": "None", "image": "assets/images/cat4.jpg", "type": "cat"},
    ];

    setState(() {
      allPetRecords = records;
      filteredPetRecords = records; // Initially show all records
    });
  }

  // Search function (filters from database list)
  void _filterPets(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPetRecords = allPetRecords;
      });
    } else {
      setState(() {
        filteredPetRecords = allPetRecords
            .where((pet) =>
        pet["name"]!.toLowerCase().contains(query.toLowerCase()) ||
            pet["breed"]!.toLowerCase().contains(query.toLowerCase()) ||
            pet["owner"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // Function to show pet details in a popup
  void _showPetDetails(Map<String, String> pet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pet["name"]!, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(pet["image"]!),  // Show pet image
              SizedBox(height: 10),
              Text("Breed: ${pet["breed"]}", style: GoogleFonts.poppins(fontSize: 16)),
              Text("Owner: ${pet["owner"]}", style: GoogleFonts.poppins(fontSize: 16)),
              Text("Age: ${pet["age"]} years", style: GoogleFonts.poppins(fontSize: 16)),
              Text("Vaccinated: ${pet["vaccinated"]}", style: GoogleFonts.poppins(fontSize: 16)),
              Text("Treatment: ${pet["treatment"]}", style: GoogleFonts.poppins(fontSize: 16)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close", style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF5A3E36))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Pet Records",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: _filterPets,
              decoration: InputDecoration(
                hintText: "Search by name, breed, or owner...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Color(0xFF5A3E36)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Pet Records List (Displays fetched data)
            Expanded(
              child: filteredPetRecords.isEmpty
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF5A3E36))) // Show loading indicator while waiting for data
                  : ListView.builder(
                itemCount: filteredPetRecords.length,
                itemBuilder: (context, index) {
                  var pet = filteredPetRecords[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Image.asset(
                        pet["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(pet["name"]!, style: GoogleFonts.poppins(fontSize: 18, color: Color(0xFF5A3E36))),
                      subtitle: Text("${pet["breed"]!} - Owner: ${pet["owner"]!}", style: GoogleFonts.poppins(color: Colors.grey)),
                      onTap: () {
                        _showPetDetails(pet); // Show pet details when tapped
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Button to Add New Pet Record
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5A3E36),
        onPressed: () {
          // Future: Open form to add pet records to database
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
