import 'package:flutter/material.dart';
import 'seat_map_page.dart';

class BookingPage extends StatefulWidget {
  final String matchName;
  final double ticketPrice;

  const BookingPage({
    super.key,
    required this.matchName,
    required this.ticketPrice,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int regularCount = 0;
  int vipCount = 0;
  int vvipCount = 0;

  // ===== Controllers للدفع =====
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // ===== حساب السعر =====
  double totalPrice() {
    return (regularCount * widget.ticketPrice) +
        (vipCount * widget.ticketPrice * 2) +
        (vvipCount * widget.ticketPrice * 4);
  }

  int totalTickets() {
    return regularCount + vipCount + vvipCount;
  }


  Widget ticketSelector(
    String title,
    int count,
    VoidCallback onAdd,
    VoidCallback onRemove,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: count > 0 ? onRemove : null,
            ),
            Text("$count"),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: totalTickets() < 1 ? onAdd : null,
            ),
          ],
        ),
      ],
    );
  }

  // ===== الانتقال لصفحة المقاعد =====
  void goToSeats() {
    if (totalTickets() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one ticket")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SeatMapPage(
          matchName: widget.matchName,
          regularCount: regularCount,
          vipCount: vipCount,
          vvipCount: vvipCount,
          totalPrice: totalPrice(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket & Payment")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.matchName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              ticketSelector(
                "Regular",
                regularCount,
                () => setState(() => regularCount++),
                () => setState(() => regularCount--),
              ),

              ticketSelector(
                "VIP (x2)",
                vipCount,
                () => setState(() => vipCount++),
                () => setState(() => vipCount--),
              ),

              ticketSelector(
                "VVIP (x4)",
                vvipCount,
                () => setState(() => vvipCount++),
                () => setState(() => vvipCount--),
              ),

              const Divider(height: 40),

              const Text(
                "Payment Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              // ===== Card Number =====
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Card Number",
                  hintText: "**** **** **** ****",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Card number is required";
                  }


                  if (value.length != 16) {
                    return "Card number must be 16 digits";
                  }


                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Digits only";
                  }


                  if (RegExp(r'^0+$').hasMatch(value)) {
                    return "Invalid card number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Expiry (MM/YY)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Expiry is required";
                        }


                        if (value.length != 5) {
                          return "Use format MM/YY";
                        }


                        if (!value.contains("/")) {
                          return "Use format MM/YY";
                        }

                        final parts = value.split("/");
                        if (parts.length != 2) {
                          return "Invalid expiry";
                        }

                        final month = int.tryParse(parts[0]);
                        final year = int.tryParse(
                          "20${parts[1]}",
                        ); // يحول 24 → 2024

                        if (month == null || year == null) {
                          return "Invalid expiry";
                        }

                        // التحقق من صحة الشهر
                        if (month < 1 || month > 12) {
                          return "Invalid month";
                        }


                        final maxAllowed = DateTime(2028, 1, 31);
                        final enteredDate = DateTime(year, month, 1);

                        if (enteredDate.isAfter(maxAllowed)) {
                          return "Expiry must not be after 01/28";
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "CVV",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "CVV is required";
                        }


                        if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                          return "Enter 3 digits only";
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ===== TOTAL PRICE =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price"),
                    Text(
                      totalPrice().toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: goToSeats,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
