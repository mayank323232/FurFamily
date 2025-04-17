import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/pet_listings_screen.dart';
import 'screens/ngo_profile_screen.dart';
import 'screens/manage_pet_screen.dart';
import 'screens/terms_and_conditions.dart';
import 'screens/ngo_home_screen.dart';
import 'screens/donation.dart'; // 💸 added this
import 'screens/adoption_form.dart';   // 🐾 and this too

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(FurFamilyApp());
}
class FurFamilyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fur Family',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/petListings': (context) => PetListingsScreen(),
        '/ngoProfile': (context) => NgoProfileScreen(),
        '/managePets': (context) => ManagePetScreen(),
        '/terms': (context) => TermsAndConditions(),
        '/ngoHome': (context) => NgoHomeScreen(isOwner: true),

        // 🔥 New screens added below
        '/donations': (context) => DonationsScreen(),
        '/adoptionForm': (context) => AdoptionRequestForm(), // default not editable
      },
    );
  }
}
