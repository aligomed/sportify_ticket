import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'league_matches_page.dart';
import 'login_page.dart';
import 'my_tickets_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AccountDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "Select League",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: leagues.length,
          itemBuilder: (context, i) {
            final league = leagues[i];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeagueMatchesPage(
                      leagueName: league["name"] as String,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (league["color"] as Color).withOpacity(.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: league["color"] as Color,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      league["logo"] as String,
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      league["name"] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


final leagues = [
  {"name": "La Liga", "logo": "assets/images/teams/laliga.png", "color": Colors.red},
  {"name": "Premier League", "logo": "assets/images/teams/premier.png", "color": Colors.purple},
  {"name": "Serie A", "logo": "assets/images/teams/seriea.png", "color": Colors.blue},
  {"name": "Bundesliga", "logo": "assets/images/teams/bundesliga.png", "color": Colors.black},
  {"name": "Champions League", "logo": "assets/images/teams/ucl.png", "color": Colors.indigo},
  {"name": "Ligue 1", "logo": "assets/images/teams/ligue 1.png", "color": Colors.cyan},
  {"name": "Fifa World Cup", "logo": "assets/images/teams/fifaworldcup.png", "color": Colors.blue},
  {"name": "CAF Africa Cup", "logo": "assets/images/teams/caff.png", "color": Colors.black},
];


//الحساب
class AccountDrawer extends StatelessWidget {
  const AccountDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() as Map<String, dynamic>?;

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(data?["name"] ?? ""),
                accountEmail: Text(user.email ?? ""),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.confirmation_number),
            title: const Text("My Tickets"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyTicketsPage(),
                ),
              );
            },
          ),


          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text("Favorites"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
