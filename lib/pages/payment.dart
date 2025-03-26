import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  // Use super.key to handle the 'key' parameter.
  const PaymentPage({super.key, required this.totalPrice});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;

  /// Handles the payment process
  Future<void> _handlePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Create PaymentIntent on your backend and retrieve the client secret.
      final paymentIntentData = await _createPaymentIntent(widget.totalPrice);

      // After awaiting, always check if the widget is still mounted
      // before using the BuildContext or calling setState.
      if (!mounted) return;

      if (paymentIntentData == null) {
        throw Exception("Failed to create PaymentIntent");
      }

      // 2. Initialize the payment sheet.
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Your Company Name',
        ),
      );

      // 3. Present the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment successful!')));
    } catch (e) {
      // Again, check if mounted before using context
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      // Safely call setState if the widget is still mounted.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Calls the backend to create a PaymentIntent.
  Future<Map<String, dynamic>?> _createPaymentIntent(double amount) async {
    try {
      // Replace with your backend endpoint.
      final url = Uri.parse('http://192.168.168.64:3000/create-payment-intent');

      // Multiply amount by 100 to convert to the smallest currency unit (if needed).
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': (amount * 100).toInt(),
          'currency': 'aed',
        }),
      );

      // Debug prints to help diagnose issues
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      // If the server returned a successful response, decode it
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // If the server did not return a 200, throw an error with the response body
        throw Exception('Failed to create PaymentIntent: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating PaymentIntent: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment'), centerTitle: true),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _handlePayment,
                  child: Text(
                    'Pay AED ${widget.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
      ),
    );
  }
}
