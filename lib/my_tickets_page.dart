import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ticket_qr_page.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tickets"),
        backgroundColor: Colors.green,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("tickets")
            .where("userId", isEqualTo: user.uid)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("No tickets yet 🎟️",
                  style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final t = docs[i].data() as Map<String, dynamic>;

              final matchName = (t["matchName"] ?? "").toString();
              final seat = (t["seat"] ?? "").toString();
              final type = (t["type"] ?? "").toString();
              final gate = (t["gate"] ?? "").toString();

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🟢 Match Title
                      Text(
                        matchName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🎫 Ticket Details Row
                      Row(
                        children: [
                          const Icon(Icons.event_seat,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 6),
                          Text("Seat: $seat"),

                          const SizedBox(width: 12),

                          const Icon(Icons.star,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 6),
                          Text("Type: $type"),

                          const SizedBox(width: 12),

                          const Icon(Icons.door_front_door,
                              color: Colors.green, size: 18),
                          const SizedBox(width: 6),
                          Text("Gate: $gate"),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Divider(),

                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tap to view QR",
                            style: TextStyle(color: Colors.grey),
                          ),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TicketQrPage(
                                    ticketId: docs[i].id,
                                    matchName: matchName,
                                    seats: seat,
                                    gate: gate,
                                  ),
                                ),
                              );
                            },

                            icon: const Icon(Icons.qr_code,
                                color: Colors.white),
                            label: const Text(
                              "Show QR",
                              style: TextStyle(color: Colors.white),
                            ),
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
