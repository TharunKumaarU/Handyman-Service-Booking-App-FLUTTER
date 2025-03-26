import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaterDamagePage extends StatefulWidget {
  const WaterDamagePage({super.key});

  @override
  State<WaterDamagePage> createState() => _WaterDamagePageState();
}

class _WaterDamagePageState extends State<WaterDamagePage> {
  String? mobileKey;
  int _quantity = 1;
  final double _itemPrice = 89;
  final double _convenienceFee = 6;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
  }

  Future<void> _saveData() async {
    if (mobileKey == null || mobileKey!.isEmpty) return;
    final double itemTotal = _quantity * _itemPrice;
    final double totalPrice = itemTotal + _convenienceFee;

    await FirebaseFirestore.instance.collection('address').doc(mobileKey).set({
      'serviceName': 'Water Damage Repair',
      'quantity': _quantity,
      'totalPrice': totalPrice,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final double itemTotal = _quantity * _itemPrice;
    final double total = itemTotal + _convenienceFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Service/Quantity Container (mimicking off_white.dart)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row with service name and price label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Water Damage Repair',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'AED ${_itemPrice.toStringAsFixed(0)}/hr',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(This service is charged on an hourly basis)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_quantity > 1) _quantity--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _quantity++);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Payment Summary Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Item Total'),
                          Text('AED ${itemTotal.toStringAsFixed(0)}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Convenience Fee'),
                          Text('AED ${_convenienceFee.toStringAsFixed(0)}'),
                        ],
                      ),
                      const Divider(thickness: 1, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'AED ${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // NOTE Container (mimicking off_white.dart)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOTE !',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'After the completion of booking, our professional will measure the exact area.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(77),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              setState(() => _isLoading = true);
              bool errorOccurred = false;
              try {
                await _saveData();
              } catch (e) {
                errorOccurred = true;
                debugPrint('Error: $e');
              }
              if (!mounted) return;
              setState(() => _isLoading = false);

              if (!errorOccurred) {
                nav.pushNamed('/slot', arguments: mobileKey);
              }
            },
            child: const Text('Book Your Slot'),
          ),
        ),
      ),
    );
  }
}
