import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SummaryPage extends StatefulWidget {
  /// The mobileKey is the mobile number (with country code) used as the Firestore document ID.
  final String mobileKey;

  const SummaryPage({super.key, required this.mobileKey});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary'), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('address').doc(widget.mobileKey).snapshots(),
        builder: (context, snapshot) {
          // Show loading indicator while connecting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If no document is found
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No order summary found.'));
          }

          // Extract document data
          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Address details
          final String fullName = data['fullName'] ?? '';
          final String house = data['house'] ?? '';
          final String apartment = data['apartment'] ?? '';
          final String area = data['area'] ?? '';
          final String pin = data['pin'] ?? '';
          final String mobile = data['mobile'] ?? '';

          // Location details
          final Map<String, dynamic> location = data['location'] ?? {};
          final double latitude = (location['latitude'] ?? 0).toDouble();
          final double longitude = (location['longitude'] ?? 0).toDouble();

          // Service/Order details
          final String serviceName = data['serviceName'] ?? '';
          final int quantity = data['quantity'] ?? 0;
          final String slotDate = data['slotDate'] ?? '';
          final String slotTime = data['slotTime'] ?? '';
          final double totalPrice = (data['totalPrice'] ?? 0).toDouble();

          // If you have a discount value in Firestore, replace this with that field.
          // Otherwise, this is just a placeholder to replicate the screenshot design.
          const double discountAmount = 15.0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top banner for discount
                Container(
                  color: Colors.orange, // Pick any color you like
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Saving AED $discountAmount on this order',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Main card containing order summary
                Card(
                  margin: const EdgeInsets.all(16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order details
                        _buildDetailRow('Name', fullName),
                        _buildDetailRow('House / Flat', house),
                        _buildDetailRow('Apartment', apartment),
                        _buildDetailRow('Area', area),
                        _buildDetailRow('Pin Code', pin),
                        const SizedBox(height: 16),

                        // Location section
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'Latitude',
                          latitude.toStringAsFixed(6),
                        ),
                        _buildDetailRow(
                          'Longitude',
                          longitude.toStringAsFixed(6),
                        ),
                        const SizedBox(height: 16),

                        // Mobile
                        _buildDetailRow('Mobile No.', mobile),
                        const SizedBox(height: 16),

                        // Service details
                        _buildDetailRow('Service', serviceName),
                        _buildDetailRow('Quantity', quantity.toString()),
                        _buildDetailRow('Slot Date', slotDate),
                        _buildDetailRow('Slot Time', slotTime),
                        const SizedBox(height: 16),

                        // Total Price
                        _buildDetailRow(
                          'Total Price',
                          'AED ${totalPrice.toStringAsFixed(2)}',
                          isBold: true,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                // "Proceed to Pay" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to PaymentPage via named route
                      // Pass the totalPrice as an argument
                      Navigator.pushNamed(
                        context,
                        '/payment',
                        arguments: totalPrice,
                      );
                    },
                    child: const Text(
                      'Proceed to Pay',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  /// A helper widget to build a simple row like: "Label: Value"
  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
