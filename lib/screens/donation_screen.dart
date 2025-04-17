import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DonationsScreen extends StatelessWidget {
  // Sample donation data (Replace with actual data from your backend later)
  final List<Map<String, String>> donations = [
    {
      "donor": "Ravi Kumar",
      "amount": "₹500",
      "date": "12 April 2025",
      "message": "For the stray dogs of the shelter",
    },
    {
      "donor": "Priya Sharma",
      "amount": "₹1000",
      "date": "10 April 2025",
      "message": "Hope this helps for the new puppies!",
    },
    {
      "donor": "Ankit Verma",
      "amount": "₹200",
      "date": "05 April 2025",
      "message": "For your good cause, keep it up!",
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text("Donations",
          style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,),
      ),
        backgroundColor: Color(0xFF5A3E36),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  donation['donor'] ?? 'Anonymous Donor',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Amount: ${donation['amount']}"),
                trailing: Icon(Icons.more_vert),
                onTap: () {
                  _showDonationDetailsDialog(context, donation);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Show a dialog with more donation details
  void _showDonationDetailsDialog(BuildContext context, Map<String, String> donation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Donation Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Donor: ${donation['donor']}"),
              SizedBox(height: 8),
              Text("Amount: ${donation['amount']}"),
              SizedBox(height: 8),
              Text("Date: ${donation['date']}"),
              SizedBox(height: 8),
              Text("Message: ${donation['message']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
