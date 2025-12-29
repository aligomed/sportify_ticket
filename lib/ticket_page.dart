import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPage extends StatelessWidget {
  final String matchName;
  final String seatNumber;
  final String gate;

  const TicketPage({
    super.key,
    required this.matchName,
    required this.seatNumber,
    required this.gate,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = "Match: $matchName\nSeat: $seatNumber\nGate: $gate";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Ticket"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              QrImageView(
                data: qrData,
                size: 220,
                backgroundColor: Colors.white,
              ),

              const SizedBox(height: 20),

              Text(
                matchName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text("Seat: $seatNumber"),
              Text("Gate: $gate"),
            ],
          ),
        ),
      ),

      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text("Done"),
        ),
      ),
    );
  }
}
