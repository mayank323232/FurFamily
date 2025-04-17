import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'vet_home_screen.dart';
import 'ngo_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = "User";
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email/Password Login
  Future<void> _loginWithEmailPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = _auth.currentUser;
      if (user != null) {
        _navigateBasedOnRole(user);
      } else {
        _showErrorDialog("Login failed. Please try again.");
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(_getErrorMessage(e.code));
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Google Sign-in
  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _navigateBasedOnRole(_auth.currentUser!);
    } catch (e) {
      _showErrorDialog("Google sign-in failed. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Navigate based on user role
  void _navigateBasedOnRole(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      _showErrorDialog("User data not found. Please try again.");
      return;
    }

    String role = userDoc['role'] ?? 'User';
    String vetName = userDoc['vetName'] ?? 'Unknown';

    if (role == "User") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (role == "Vet") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VetHomeScreen(vetName: vetName)));
    } else if (role == "NGO") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NgoHomeScreen(isOwner: true)));
    }
  }

  // Error message handler
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Login failed. Please try again';
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Error', style: GoogleFonts.poppins()),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            child: Text('OK', style: GoogleFonts.poppins(color: Color(0xFF5A3E36))),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEED7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome to Fur Family!",
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
              ),
              SizedBox(height: 10),
              Text(
                "Find loving homes for pets",
                style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF7A5C4F)),
              ),
              SizedBox(height: 30),
              _buildRoleSelection(),
              SizedBox(height: 15),
              _buildTextField(emailController, "Email", Icons.email),
              SizedBox(height: 15),
              _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
              SizedBox(height: 20),
              _buildLoginButton(),
              SizedBox(height: 15),
              _buildGoogleButton(),
              SizedBox(height: 20),
              _buildEmergencyButton(context),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: GoogleFonts.poppins()),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: Text("Sign Up", style: TextStyle(color: Color(0xFF5A3E36))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Role selection buttons
  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Role:",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _roleButton("User", "User (Adopter)", Icons.person),
            _roleButton("Vet", "Vet", Icons.local_hospital),
            _roleButton("NGO", "NGO", Icons.business),
          ],
        ),
      ],
    );
  }

  // Role button builder
  Widget _roleButton(String roleValue, String label, IconData icon) {
    bool isSelected = selectedRole == roleValue;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Color(0xFF5A3E36) : Colors.white,
            foregroundColor: isSelected ? Colors.white : Color(0xFF5A3E36),
            elevation: isSelected ? 4 : 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Color(0xFF5A3E36))),
          ),
          onPressed: () {
            setState(() {
              selectedRole = roleValue;
            });
          },
          icon: Icon(icon, size: 18),
          label: Text(label, style: GoogleFonts.poppins(fontSize: 12)),
        ),
      ),
    );
  }

  // Text field builder
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
        prefixIcon: Icon(icon, color: Color(0xFF5A3E36)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  // Login button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5A3E36), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: _isLoading ? null : _loginWithEmailPassword,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          "Login",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // Google login button
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF7A5C4F)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoading ? null : _loginWithGoogle,
        icon: Image.asset('assets/images/google.png', height: 20),
        label: Text("Sign in with Google", style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF5A3E36))),
      ),
    );
  }

  // Emergency contact button
  Widget _buildEmergencyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("🚨 Emergency Contact", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Call for help:", style: GoogleFonts.poppins()),
                  Text("Faculty: 123-456-7890", style: GoogleFonts.poppins()),
                  Text("Security Guard: 987-654-3210", style: GoogleFonts.poppins()),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close", style: GoogleFonts.poppins()),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.phone, size: 20),
        label: Text("Emergency", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
