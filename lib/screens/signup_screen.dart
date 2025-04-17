import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedRole = 'user';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _signUpWithEmailPassword() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if email already exists in Firebase Auth
      final signInMethods = await _auth.fetchSignInMethodsForEmail(emailController.text.trim());

      if (signInMethods.isNotEmpty) {
        _showErrorDialog('Email is already registered');
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await userCredential.user?.sendEmailVerification();

      await _saveUserDataToFirestore(
        userCredential.user!.uid,
        nameController.text.trim(),
        emailController.text.trim(),
        _selectedRole,
      );

      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(_getErrorMessage(e.code));
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserDataToFirestore(
      String userId,
      String name,
      String email,
      String role,
      ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': role,
        'emailVerified': false,
      });
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        await _saveUserDataToFirestore(
          userCredential.user!.uid,
          userCredential.user!.displayName ?? 'Google User',
          userCredential.user!.email ?? '',
          _selectedRole,
        );
      }

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog("Google sign-up failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email already registered';
      case 'invalid-email':
        return 'Invalid email format';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts not enabled';
      default:
        return 'Signup failed. Please try again';
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Signup Error', style: GoogleFonts.poppins()),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success!', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account created successfully!', style: GoogleFonts.poppins()),
            SizedBox(height: 10),
            Text('Please verify your email before logging in.',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK', style: GoogleFonts.poppins(color: Color(0xFF5A3E36))),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
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
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Create an Account",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A3E36),
                ),
              ),
              SizedBox(height: 10),
              _buildTextField(nameController, "Full Name", Icons.person),
              SizedBox(height: 15),
              _buildTextField(emailController, "Email", Icons.email),
              SizedBox(height: 15),
              _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
              SizedBox(height: 15),
              _buildTextField(confirmPasswordController, "Confirm Password", Icons.lock, isPassword: true),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: ['user', 'vet', 'ngo'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role[0].toUpperCase() + role.substring(1), style: GoogleFonts.poppins()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Select Role",
                  labelStyle: GoogleFonts.poppins(color: Color(0xFF5A3E36)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildSignupButton(),
              SizedBox(height: 15),
              _buildGoogleButton(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: GoogleFonts.poppins()),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Login", style: TextStyle(color: Color(0xFF5A3E36))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF5A3E36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoading ? null : _signUpWithEmailPassword,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          "Sign Up",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFF7A5C4F)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isLoading ? null : _signUpWithGoogle,
        icon: Image.asset('assets/images/google.png', height: 20),
        label: Text(
          "Sign up with Google",
          style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF5A3E36)),
        ),
      ),
    );
  }
}
