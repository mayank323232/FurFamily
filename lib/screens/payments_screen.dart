import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentsScreen extends StatefulWidget {
  final String ngoName;

  PaymentsScreen({required this.ngoName});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedMethod = 'UPI';
  bool _isPaying = false;

  final List<String> _methods = ['UPI', 'Credit/Debit Card', 'Net Banking', 'Wallets'];

  void _handlePayment() {
    String amount = _amountController.text.trim();

    if (amount.isEmpty || double.tryParse(amount) == null || double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yo, enter a valid amount, bruh 💸")),
      );
      return;
    }

    setState(() => _isPaying = true);

    // Simulate payment delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isPaying = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text("Payment Successful!",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            "₹${amount} sent to ${widget.ngoName} via $_selectedMethod.\n\nAppreciate the kindness, king 👑",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            TextButton(
              child: Text("Close", style: GoogleFonts.poppins(color: Color(0xFF5A3E36))),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to NGO screen
              },
            ),
          ],
        ),
      );

      // Clear inputs
      _amountController.clear();
      _noteController.clear();
      setState(() => _selectedMethod = 'UPI');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      appBar: AppBar(
        title: Text(
          "Payments",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF5A3E36),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isPaying
          ? Center(child: CircularProgressIndicator(color: Color(0xFF5A3E36)))
          : Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Paying to: ${widget.ngoName}",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 25),
            Text("Amount (₹)", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Enter amount"),
            ),
            SizedBox(height: 20),
            Text("Payment Method", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              items: _methods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method, style: GoogleFonts.poppins()),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedMethod = value!),
              decoration: _inputDecoration("Select method"),
            ),
            SizedBox(height: 20),
            Text("Note (optional)", style: GoogleFonts.poppins(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: _inputDecoration("Like: for food, rescue, meds..."),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: _handlePayment,
                icon: Icon(Icons.payment, color: Colors.white),
                label: Text("Pay Now", style: GoogleFonts.poppins(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5A3E36),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
