import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ticket_page.dart';

class SeatMapPage extends StatefulWidget {
  final String matchName;
  final int regularCount;
  final int vipCount;
  final int vvipCount;
  final double totalPrice;

  const SeatMapPage({
    super.key,
    required this.matchName,
    required this.regularCount,
    required this.vipCount,
    required this.vvipCount,
    required this.totalPrice,
  });

  @override
  State<SeatMapPage> createState() => _SeatMapPageState();
}

class _SeatMapPageState extends State<SeatMapPage> {
  final List<int> regularSeats = [];
  final List<int> vipSeats = [];
  final List<int> vvipSeats = [];

  bool _saving = false;

  // ===================== SEAT GRID =====================
  Widget seatGrid({
    required String title,
    required int totalSeats,
    required int maxSelectable,
    required List<int> selectedSeats,
    required Color activeColor,
  }) {
    if (maxSelectable == 0) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title (Select $maxSelectable)",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: totalSeats,
          itemBuilder: (context, index) {
            final isSelected = selectedSeats.contains(index);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSeats.remove(index);
                  } else {
                    if (selectedSeats.length < maxSelectable) {
                      selectedSeats.add(index);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "You can only select $maxSelectable seats"),
                        ),
                      );
                    }
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "S${index + 1}",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ===================== CONFIRM BOOKING =====================
  Future<void> _confirmBooking() async {
    if (_saving) return;

    if (regularSeats.length != widget.regularCount ||
        vipSeats.length != widget.vipCount ||
        vvipSeats.length != widget.vvipCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all seats you booked")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final ticketsRef = firestore.collection('tickets');
      final batch = firestore.batch();

      final gates = ["Gate A", "Gate B", "Gate C", "Gate D"];
      String gate = (gates..shuffle()).first;

      // Prevent duplicate seat booking
      Future<bool> seatTaken(String seat) async {
        final q = await ticketsRef
            .where("matchName", isEqualTo: widget.matchName)
            .where("seat", isEqualTo: seat)
            .limit(1)
            .get();
        return q.docs.isNotEmpty;
      }

      List<String> selectedSeatLabels = [];

      // Regular
      for (final seat in regularSeats) {
        final seatCode = "S${seat + 1}";

        if (await seatTaken(seatCode)) {
          throw "Seat $seatCode already booked";
        }

        selectedSeatLabels.add(seatCode);

        batch.set(ticketsRef.doc(), {
          "userId": user.uid,
          "matchName": widget.matchName,
          "seat": seatCode,
          "type": "Regular",
          "gate": gate,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      // VIP
      for (final seat in vipSeats) {
        final seatCode = "S${seat + 1}";

        if (await seatTaken(seatCode)) {
          throw "Seat $seatCode already booked";
        }

        selectedSeatLabels.add("$seatCode (VIP)");

        batch.set(ticketsRef.doc(), {
          "userId": user.uid,
          "matchName": widget.matchName,
          "seat": seatCode,
          "type": "VIP",
          "gate": gate,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      // VVIP
      for (final seat in vvipSeats) {
        final seatCode = "S${seat + 1}";

        if (await seatTaken(seatCode)) {
          throw "Seat $seatCode already booked";
        }

        selectedSeatLabels.add("$seatCode (VVIP)");

        batch.set(ticketsRef.doc(), {
          "userId": user.uid,
          "matchName": widget.matchName,
          "seat": seatCode,
          "type": "VVIP",
          "gate": gate,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking confirmed 🎉")),
      );

      // 🔹 إرسال اسم المقعد الحقيقي إلى TicketPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TicketPage(
            matchName: widget.matchName,
            seatNumber: selectedSeatLabels.join(", "),
            gate: gate,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Seats")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            seatGrid(
              title: "Regular Seats",
              totalSeats: 30,
              maxSelectable: widget.regularCount,
              selectedSeats: regularSeats,
              activeColor: Colors.blue,
            ),
            seatGrid(
              title: "VIP Seats",
              totalSeats: 18,
              maxSelectable: widget.vipCount,
              selectedSeats: vipSeats,
              activeColor: Colors.orange,
            ),
            seatGrid(
              title: "VVIP Seats",
              totalSeats: 12,
              maxSelectable: widget.vvipCount,
              selectedSeats: vvipSeats,
              activeColor: Colors.red,
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _saving ? null : _confirmBooking,
              child: _saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Confirm Booking"),
            )
          ],
        ),
      ),
    );
  }
}
