import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetListingsScreen extends StatelessWidget {
  final String? category;

  PetListingsScreen({this.category});

  final List<Map<String, String>> pets = [
    {
      "name": "Dharam Paal",
      "image": "assets/images/dog1.jpg",
      "description": "Bhai ka swag alag hai! Full on desi vibes.",
      "ngo": "Desi Doggo Shelter"
    },
    {
      "name": "Buddy",
      "image": "assets/images/dog2.jpg",
      "description": "Golden boi with soft ears. He's like a cuddly teddy bear.",
      "ngo": "Golden Heart NGO"
    },
    {
      "name": "Simba",
      "image": "assets/images/cat1.jpg",
      "description": "Maharaja vibes – 3 years old, ready to rule the house.",
      "ngo": "Royal Paws Foundation"
    },
    {
      "name": "Misty",
      "image": "assets/images/cat2.jpg",
      "description": "Fluffy AF, causes chaos but also owns the heart of the house.",
      "ngo": "Fluff Rescue"
    },
    {
      "name": "Sheru",
      "image": "assets/images/dog3.jpg",
      "description": "Loyal AF, guards your thali (and your heart).",
      "ngo": "Noida Stray Help"
    },
    {
      "name": "Moti",
      "image": "assets/images/dog4.jpg",
      "description": "Thoda mota, but bohot pyara. He’s your cuddle buddy.",
      "ngo": "Gully Wale Tails"
    },
    {
      "name": "Kalu",
      "image": "assets/images/dog5.jpg",
      "description": "Chases bikes like a boss. Will protect your home, but also run after the neighbor’s bike.",
      "ngo": "Desi Doggo Shelter"
    },
    {
      "name": "Bholu",
      "image": "assets/images/dog6.jpg",
      "description": "Sleeps 22 hours a day. The other 2, he’s plotting his next nap.",
      "ngo": "Street Love Org"
    },
    {
      "name": "Chintu",
      "image": "assets/images/cat3.jpg",
      "description": "Jumps like Spiderman, but doesn’t get up when you call him.",
      "ngo": "Cat Squad"
    },
    {
      "name": "Golu",
      "image": "assets/images/cat4.jpg",
      "description": "Rolling is cardio for him, and he’s working on it.",
      "ngo": "Chonky Friends NGO"
    },
    {
      "name": "Tinku",
      "image": "assets/images/dog7.jpg",
      "description": "Jumping legend of East Delhi, will bounce into your heart.",
      "ngo": "Adopt n Love"
    },
    {
      "name": "Sundari",
      "image": "assets/images/cat5.jpg",
      "description": "Walks like a fashion show model. Absolute diva.",
      "ngo": "Royal Paws Foundation"
    },
    {
      "name": "Raja",
      "image": "assets/images/dog8.jpg",
      "description": "Majestic like his name, but also a little extra sometimes.",
      "ngo": "Noida Stray Help"
    },
    {
      "name": "Babli",
      "image": "assets/images/cat6.jpg",
      "description": "Steals food and hearts – both at the same time.",
      "ngo": "Whisker Town"
    },
    {
      "name": "Rocky",
      "image": "assets/images/dog9.jpg",
      "description": "Rebel without a leash. Does not follow any rules.",
      "ngo": "Pawsitive Souls"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPets = category == null
        ? pets
        : pets.where((pet) {
      final isDog = pet['image']!.toLowerCase().contains('dog');
      final isCat = pet['image']!.toLowerCase().contains('cat');
      return (category == "dog" && isDog) ||
          (category == "cat" && isCat);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Listings",
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF5A3E36),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(context, 'assets/images/paw.png', "All", null),
                _buildCategoryIcon(context, 'assets/images/dog.jpg', "Dogs", "dog"),
                _buildCategoryIcon(context, 'assets/images/cat.jpg', "Cats", "cat"),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: filteredPets.length,
                itemBuilder: (context, index) {
                  return _buildPetCard(context, filteredPets[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context, String imagePath, String label, String? category) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PetListingsScreen(category: category),
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.shade100,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, String> pet) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: ClipOval(
          child: Image.asset(
            pet["image"]!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.pets, size: 60, color: Colors.grey);
            },
          ),
        ),
        title: Text(
          pet["name"]!,
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A3E36)),
        ),
        subtitle: Text(pet["description"]!, style: GoogleFonts.poppins()),
        trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF5A3E36)),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFBEED7), Color(0xFFEACBA4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade200,
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          pet["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(pet["name"]!,
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5A3E36))),
                    SizedBox(height: 8),
                    Text(pet["description"]!,
                        style: GoogleFonts.poppins(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("NGO: ${pet["ngo"]!}",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87)),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5A3E36),
                        padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Contacting ${pet["ngo"]!}..."),
                              backgroundColor: Colors.orange),
                        );
                      },
                      icon: Icon(Icons.call),
                      label: Text("Contact NGO", style: GoogleFonts.poppins()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
