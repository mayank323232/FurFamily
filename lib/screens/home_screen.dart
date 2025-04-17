// Your imports stay the same
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fur_family/screens/login_screen.dart';
import 'package:fur_family/screens/pet_listings_screen.dart';
import 'package:fur_family/screens/registered_ngos_screen.dart';
import 'package:fur_family/screens/user_appointments_screen.dart';
import 'package:fur_family/screens/vet_list_screen.dart';
import 'package:fur_family/screens/user_profile_screen.dart';
import 'package:fur_family/utils/appointment_manager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Alex";
  int _selectedIndex = 0;

  final List<Map<String, String>> featuredPets = [
    {
      "name": "Dharam Paal",
      "image": "assets/images/dog1.jpg",
      "description": "Bhai ka swag alag hai!",
    },
    {
      "name": "Moti",
      "image": "assets/images/dog4.jpg",
      "description": "Street-smart and super friendly",
    },
    {
      "name": "Simba",
      "image": "assets/images/cat1.jpg",
      "description": "Maharaja vibes - 3 years old",
    },
    {
      "name": "Chintu",
      "image": "assets/images/cat3.jpg",
      "description": "King of the rooftop",
    },
  ];

  void _onBottomNavTap(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PetListingsScreen()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => UserAppointmentsScreen()));
    }
    setState(() => _selectedIndex = index);
  }

  void _logoutUser() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirm Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to log out?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey[700])),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text("Logout", style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFFBEED7),
        appBar: AppBar(
          title: Text(
            "Fur Family",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xFF5A3E36),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: _buildSideDrawer(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey, $userName! Ready to find your fur buddy?",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A3E36),
                ),
              ),
              SizedBox(height: 15),
              _buildFeaturedPets(),
              SizedBox(height: 20),
              _buildNGOShelterSection(context),
              SizedBox(height: 20),
              _buildVetAppointments(context),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0xFF5A3E36),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: "View Pets"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Appointments"),
          ],
        ),
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF5A3E36)),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/user_placeholder.jpg"),
                  radius: 35,
                ),
                SizedBox(height: 10),
                Text(
                  "Alex Johnson",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, "Profile", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileScreen()));
          }),
          _buildDrawerItem(Icons.list_alt, "Vet List", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => VetListScreen()));
          }),
          _buildDrawerItem(Icons.calendar_today, "Appointments", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => UserAppointmentsScreen()));
          }),
          _buildDrawerItem(Icons.home_work, "NGO Shelters", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => RegisteredNGOsScreen()));
          }),
          Divider(),
          _buildDrawerItem(Icons.exit_to_app, "Logout", _logoutUser),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF5A3E36)),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildFeaturedPets() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredPets.length,
        itemBuilder: (context, index) {
          final pet = featuredPets[index];
          return _buildFeaturedPetCard(pet['name']!, pet['description']!, pet['image']!);
        },
      ),
    );
  }

  Widget _buildFeaturedPetCard(String name, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text(name,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A3E36))),
                    SizedBox(height: 4),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVetAppointments(BuildContext context) {
    final appointments = AppointmentManager.getAppointments();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text("Vet Appointments", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        subtitle: Text(
          appointments.isNotEmpty
              ? "Next: ${appointments.last['date']} - ${appointments.last['vetName']}"
              : "No upcoming appointments",
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserAppointmentsScreen()));
        },
      ),
    );
  }

  Widget _buildNGOShelterSection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.volunteer_activism, color: Color(0xFF5A3E36)),
        title: Text("NGO Shelters", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        subtitle: Text("Explore adoption and donation options"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => RegisteredNGOsScreen()));
        },
      ),
    );
  }
}
