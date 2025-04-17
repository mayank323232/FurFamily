import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdoptionRequestsScreen extends StatefulWidget {
  @override
  _AdoptionRequestsScreenState createState() => _AdoptionRequestsScreenState();
}

class _AdoptionRequestsScreenState extends State<AdoptionRequestsScreen> {
  // Temporary dummy data (replace this later with backend data)
  List<Map<String, String>> adoptionRequests = [
    {
      'name': 'John Doe',
      'pet': 'Golden Retriever - Max',
      'email': 'john.doe@example.com',
      'reason': 'Looking for a companion pet',
    },
    {
      'name': 'Jane Smith',
      'pet': 'Persian Cat - Snowball',
      'email': 'jane.smith@example.com',
      'reason': 'Love cats, lost mine recently',
    },
  ];

  void acceptRequest(int index) {
    // Later: Add backend call to update status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request Accepted ✅')),
    );
    setState(() {
      adoptionRequests.removeAt(index);
    });
  }

  void rejectRequest(int index) {
    // Later: Add backend call to update status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request Rejected ❌')),
    );
    setState(() {
      adoptionRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adoption Requests",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF5A3E36),
      ),
      backgroundColor: Color(0xFFFBEED7),
      body: adoptionRequests.isEmpty
          ? Center(
        child: Text(
          "No pending requests!",
          style: GoogleFonts.poppins(fontSize: 18, color: Color(0xFF5A3E36)),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: adoptionRequests.length,
        itemBuilder: (context, index) {
          final request = adoptionRequests[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${request['name']}",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("Pet: ${request['pet']}", style: GoogleFonts.poppins(fontSize: 15)),
                  SizedBox(height: 8),
                  Text("Email: ${request['email']}", style: GoogleFonts.poppins(fontSize: 15)),
                  SizedBox(height: 8),
                  Text("Reason: ${request['reason']}",
                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => acceptRequest(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text("Accept", style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => rejectRequest(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: Icon(Icons.close, color: Colors.white),
                        label: Text("Reject", style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
