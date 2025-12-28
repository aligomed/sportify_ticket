import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQrPage extends StatelessWidget {
  final String matchName;
  final String seats;
  final String gate;
  final String ticketId;

  const TicketQrPage({
    super.key,
    required this.matchName,
    required this.seats,
    required this.gate,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = "$ticketId|$matchName|$seats|$gate";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Ticket QR"),
        backgroundColor: Colors.green,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(matchName, style: const TextStyle(fontSize: 18)),
              Text("Seat: $seats"),
              Text("Gate: $gate"),

              const SizedBox(height: 20),

              QrImageView(
                data: qrData,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
