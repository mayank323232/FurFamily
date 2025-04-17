import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationsScreen extends StatefulWidget {
  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'UPI';

  final List<String> _paymentMethods = ['UPI', 'Card', 'Net Banking'];

  void _handleDonation() {
    String name = _nameController.text.trim();
    String amount = _amountController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter your name")),
      );
      return;
    }

    if (amount.isEmpty || double.tryParse(amount) == null || double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid donation amount")),
      );
      return;
    }

    // Fake payment simulation delay and navigate to success page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationSuccessScreen(donorName: name, amount: amount),
      ),
    );

    _amountController.clear();
    _nameController.clear();
    setState(() {
      _selectedPaymentMethod = 'UPI';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Donate to Shelter",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Name",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 20),
              Text("Enter Donation Amount (₹)",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ex: 500",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 25),
              Text("Select Payment Method",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method, style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _handleDonation,
                  icon: Icon(Icons.volunteer_activism, color: Colors.white),
                  label: Text("Donate Now", style: GoogleFonts.poppins(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A3E36),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DonationSuccessScreen extends StatelessWidget {
  final String donorName;
  final String amount;

  DonationSuccessScreen({required this.donorName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/donation_success.png', // <- Place your animation image here
                height: 200,
              ),
              SizedBox(height: 30),
              Text(
                "Thank You, $donorName!",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "Your generous donation of ₹$amount has been received.",
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back to Home", style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5A3E36),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
