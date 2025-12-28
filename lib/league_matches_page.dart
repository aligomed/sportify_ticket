import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'booking_page.dart';

class LeagueMatchesPage extends StatelessWidget {
  final String leagueName;

  const LeagueMatchesPage({
    super.key,
    required this.leagueName,
  });


  String favId(Map<String, dynamic> m) =>
      "$leagueName-${m['t1']}-${m['t2']}";

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final Map<String, List<Map<String, dynamic>>> matchesByLeague = {

      // 🇪🇸 LA LIGA
      "La Liga": [
        {
          "t1": "Barcelona",
          "t2": "Atletico Madrid",
          "logo1": "assets/images/teams/fcb.png",
          "logo2": "assets/images/teams/atm.png",
          "stadium": "Camp Nou",
          "date": "20 Oct 2025",
          "time": "21:00",
          "priceText": "95 EUR",
          "price": 95.0
        },
        {
          "t1": "Real Madrid",
          "t2": "Sevilla",
          "logo1": "assets/images/teams/rm.png",
          "logo2": "assets/images/teams/sev.png",
          "stadium": "Santiago Bernabéu",
          "date": "22 Oct 2025",
          "time": "20:30",
          "priceText": "110 EUR",
          "price": 110.0
        },
        {
          "t1": "Valencia",
          "t2": "Villareal",
          "logo1": "assets/images/teams/val.png",
          "logo2": "assets/images/teams/vil.png",
          "stadium": "Mestalla",
          "date": "25 Oct 2025",
          "time": "19:45",
          "priceText": "80 EUR",
          "price": 80.0
        },
        {
          "t1": "Real Betis",
          "t2": "Athletic Bilbao",
          "logo1": "assets/images/teams/bet.png",
          "logo2": "assets/images/teams/bil.png",
          "stadium": "Benito Villamarín",
          "date": "27 Oct 2025",
          "time": "22:00",
          "priceText": "75 EUR",
          "price": 75.0
        },
        {
          "t1": "Real Sociedad",
          "t2": "Celta Vigo",
          "logo1": "assets/images/teams/soc.png",
          "logo2": "assets/images/teams/cel.png",
          "stadium": "Anoeta Stadium",
          "date": "29 Oct 2025",
          "time": "21:15",
          "priceText": "70 EUR",
          "price": 70.0
        },
      ],

      // 🏴 PREMIER LEAGUE
      "Premier League": [
        {
          "t1": "Man City",
          "t2": "Chelsea",
          "logo1": "assets/images/teams/manc.png",
          "logo2": "assets/images/teams/che.png",
          "stadium": "Etihad Stadium",
          "date": "18 Oct 2025",
          "time": "22:00",
          "priceText": "110 GBP",
          "price": 110.0
        },
        {
          "t1": "Liverpool",
          "t2": "Arsenal",
          "logo1": "assets/images/teams/liv.png",
          "logo2": "assets/images/teams/ars.png",
          "stadium": "Anfield",
          "date": "19 Oct 2025",
          "time": "21:45",
          "priceText": "105 GBP",
          "price": 105.0
        },
        {
          "t1": "Man United",
          "t2": "Tottenham",
          "logo1": "assets/images/teams/mnu.png",
          "logo2": "assets/images/teams/tot.png",
          "stadium": "Old Trafford",
          "date": "21 Oct 2025",
          "time": "20:30",
          "priceText": "98 GBP",
          "price": 98.0
        },
        {
          "t1": "Newcastle",
          "t2": "West Ham",
          "logo1": "assets/images/teams/new.png",
          "logo2": "assets/images/teams/whu.png",
          "stadium": "St James Park",
          "date": "23 Oct 2025",
          "time": "22:15",
          "priceText": "90 GBP",
          "price": 90.0
        },
        {
          "t1": "Aston Villa",
          "t2": "Brighton",
          "logo1": "assets/images/teams/avl.png",
          "logo2": "assets/images/teams/bri.png",
          "stadium": "Villa Park",
          "date": "25 Oct 2025",
          "time": "19:30",
          "priceText": "85 GBP",
          "price": 85.0
        },
      ],

      // 🇮🇹 SERIE A
      "Serie A": [
        {
          "t1": "AC Milan",
          "t2": "Inter Milan",
          "logo1": "assets/images/teams/milan.png",
          "logo2": "assets/images/teams/inter.png",
          "stadium": "San Siro",
          "date": "25 Oct 2025",
          "time": "21:30",
          "priceText": "90 EUR",
          "price": 90.0
        },
        {
          "t1": "Juventus",
          "t2": "Napoli",
          "logo1": "assets/images/teams/juv.png",
          "logo2": "assets/images/teams/nap.png",
          "stadium": "Allianz Stadium",
          "date": "27 Oct 2025",
          "time": "22:00",
          "priceText": "100 EUR",
          "price": 100.0
        },
        {
          "t1": "Roma",
          "t2": "Lazio",
          "logo1": "assets/images/teams/roma.png",
          "logo2": "assets/images/teams/laz.png",
          "stadium": "Stadio Olimpico",
          "date": "28 Oct 2025",
          "time": "21:00",
          "priceText": "88 EUR",
          "price": 88.0
        },
        {
          "t1": "Fiorentina",
          "t2": "Torino",
          "logo1": "assets/images/teams/fio.png",
          "logo2": "assets/images/teams/tor.png",
          "stadium": "Artemio Franchi",
          "date": "30 Oct 2025",
          "time": "20:45",
          "priceText": "75 EUR",
          "price": 75.0
        },
        {
          "t1": "Atalanta",
          "t2": "Udinese",
          "logo1": "assets/images/teams/ata.png",
          "logo2": "assets/images/teams/udi.png",
          "stadium": "Gewiss Stadium",
          "date": "31 Oct 2025",
          "time": "21:30",
          "priceText": "72 EUR",
          "price": 72.0
        },
      ],

      // 🇩🇪 BUNDESLIGA
      "Bundesliga": [
        {
          "t1": "Bayern Munich",
          "t2": "BVB",
          "logo1": "assets/images/teams/bayern.png",
          "logo2": "assets/images/teams/bvb.png",
          "stadium": "Allianz Arena",
          "date": "20 Oct 2025",
          "time": "20:30",
          "priceText": "95 EUR",
          "price": 95.0
        },
        {
          "t1": "Leipzig",
          "t2": "Leverkusen",
          "logo1": "assets/images/teams/rbl.png",
          "logo2": "assets/images/teams/lev.png",
          "stadium": "Red Bull Arena",
          "date": "22 Oct 2025",
          "time": "21:00",
          "priceText": "85 EUR",
          "price": 85.0
        },
        {
          "t1": "Frankfurt",
          "t2": "Stuttgart",
          "logo1": "assets/images/teams/frankfurt.png",
          "logo2": "assets/images/teams/stu.png",
          "stadium": "Deutsche Bank Park",
          "date": "24 Oct 2025",
          "time": "19:45",
          "priceText": "78 EUR",
          "price": 78.0
        },
        {
          "t1": "Wolfsburg",
          "t2": "Freiburg",
          "logo1": "assets/images/teams/wol.png",
          "logo2": "assets/images/teams/fre.png",
          "stadium": "Volkswagen Arena",
          "date": "27 Oct 2025",
          "time": "22:00",
          "priceText": "72 EUR",
          "price": 72.0
        },
        {
          "t1": "Gladbach",
          "t2": "Hoffenheim",
          "logo1": "assets/images/teams/gbh.png",
          "logo2": "assets/images/teams/hof.png",
          "stadium": "Borussia-Park",
          "date": "29 Oct 2025",
          "time": "21:15",
          "priceText": "70 EUR",
          "price": 70.0
        },
      ],

      // 🇫🇷 LIGUE 1
      "Ligue 1": [
        {
          "t1": "PSG",
          "t2": "Marseille",
          "logo1": "assets/images/teams/psg.png",
          "logo2": "assets/images/teams/om.png",
          "stadium": "Parc des Princes",
          "date": "18 Oct 2025",
          "time": "21:45",
          "priceText": "120 EUR",
          "price": 120.0
        },
        {
          "t1": "Lyon",
          "t2": "Monaco",
          "logo1": "assets/images/teams/lyon.png",
          "logo2": "assets/images/teams/monaco.png",
          "stadium": "Groupama Stadium",
          "date": "21 Oct 2025",
          "time": "20:30",
          "priceText": "95 EUR",
          "price": 95.0
        },
        {
          "t1": "Lille",
          "t2": "Rennes",
          "logo1": "assets/images/teams/lille.png",
          "logo2": "assets/images/teams/rennes.png",
          "stadium": "Stade Pierre-Mauroy",
          "date": "23 Oct 2025",
          "time": "22:00",
          "priceText": "88 EUR",
          "price": 88.0
        },
        {
          "t1": "Nice",
          "t2": "Lens",
          "logo1": "assets/images/teams/nice.png",
          "logo2": "assets/images/teams/lens.png",
          "stadium": "Allianz Riviera",
          "date": "26 Oct 2025",
          "time": "19:30",
          "priceText": "82 EUR",
          "price": 82.0
        },
        {
          "t1": "Toulouse",
          "t2": "Nantes",
          "logo1": "assets/images/teams/tfc.png",
          "logo2": "assets/images/teams/nan.png",
          "stadium": "Stadium de Toulouse",
          "date": "29 Oct 2025",
          "time": "21:00",
          "priceText": "75 EUR",
          "price": 75.0
        },
      ],

      // ⭐ CHAMPIONS LEAGUE
      "Champions League": [
        {
          "t1": "Real Madrid",
          "t2": "Man City",
          "logo1": "assets/images/teams/rm.png",
          "logo2": "assets/images/teams/manc.png",
          "stadium": "Bernabéu",
          "date": "05 Nov 2025",
          "time": "22:00",
          "priceText": "140 EUR",
          "price": 140.0
        },
        {
          "t1": "Barcelona",
          "t2": "Bayern Munich",
          "logo1": "assets/images/teams/fcb.png",
          "logo2": "assets/images/teams/bayern.png",
          "stadium": "Camp Nou",
          "date": "06 Nov 2025",
          "time": "22:00",
          "priceText": "135 EUR",
          "price": 135.0
        },
        {
          "t1": "PSG",
          "t2": "Juventus",
          "logo1": "assets/images/teams/psg.png",
          "logo2": "assets/images/teams/juv.png",
          "stadium": "Parc des Princes",
          "date": "10 Nov 2025",
          "time": "21:45",
          "priceText": "130 EUR",
          "price": 130.0
        },
        {
          "t1": "Liverpool",
          "t2": "Inter Milan",
          "logo1": "assets/images/teams/liv.png",
          "logo2": "assets/images/teams/inter.png",
          "stadium": "Anfield",
          "date": "12 Nov 2025",
          "time": "22:00",
          "priceText": "128 EUR",
          "price": 128.0
        },
        {
          "t1": "Dortmund",
          "t2": "Atletico Madrid",
          "logo1": "assets/images/teams/bvb.png",
          "logo2": "assets/images/teams/atm.png",
          "stadium": "Signal Iduna Park",
          "date": "14 Nov 2025",
          "time": "22:00",
          "priceText": "120 EUR",
          "price": 120.0
        },

      ],



    };

    final matches = matchesByLeague[leagueName] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(leagueName),
        centerTitle: true,
      ),


      body: matches.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              "Soon..",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Matches for $leagueName will be added shortly.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("favorites")
            .snapshots(),
        builder: (context, snap) {
          final favDocs = snap.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, i) {
              final m = matches[i];
              final id = favId(m);
              final isFav = favDocs.any((d) => d.id == id);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(m["logo1"], height: 34),
                                const SizedBox(width: 8),
                                Text(
                                  m["t1"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    "VS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                Text(
                                  m["t2"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(m["logo2"], height: 34),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () async {
                              final ref = FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(uid)
                                  .collection("favorites")
                                  .doc(id);

                              if (isFav) {
                                await ref.delete();
                              } else {
                                await ref.set({
                                  ...m,
                                  "league": leagueName,
                                  "createdAt":
                                  FieldValue.serverTimestamp(),
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(m["stadium"]),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          Text("${m["date"]} — ${m["time"]}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            m["priceText"],
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingPage(
                                    matchName: "${m["t1"]} vs ${m["t2"]}",
                                    ticketPrice: m["price"] as double,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Book"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}