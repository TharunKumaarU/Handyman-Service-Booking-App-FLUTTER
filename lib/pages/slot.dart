import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotPage extends StatefulWidget {
  const SlotPage({super.key});

  @override
  State<SlotPage> createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  String? mobileKey;

  late List<DateTime> _dateOptions;
  DateTime? _selectedDate;
  final List<String> _timeOptions = [
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
  ];
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _generateDateOptions();
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      mobileKey = args;
    }
  }

  void _generateDateOptions() {
    final now = DateTime.now();
    _dateOptions = List.generate(
      7,
      (index) => DateTime(now.year, now.month, now.day + index),
    );
  }

  Future<void> _saveSlotDetails() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time first')),
      );
      return;
    }
    if (mobileKey == null || mobileKey!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mobile key is not available')),
      );
      return;
    }

    final dateFormatted = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    bool errorOccurred = false;
    try {
      await FirebaseFirestore.instance.collection('address').doc(mobileKey).set(
        {'slotDate': dateFormatted, 'slotTime': _selectedTime},
        SetOptions(merge: true),
      );
    } catch (e) {
      errorOccurred = true;
      messenger.showSnackBar(
        SnackBar(content: Text('Error updating slot: $e')),
      );
    }

    if (!mounted) return;

    if (!errorOccurred) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Slot updated: Date: $dateFormatted, Time: $_selectedTime',
          ),
        ),
      );
      // Pass the mobileKey as a Map to SummaryPage
      nav.pushReplacementNamed(
        '/summary_page',
        arguments: {'mobileKey': mobileKey},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Slot'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'When should the professional arrive?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Service will take approx 1 hr & 30 mins'),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _dateOptions.map((date) {
                      final dateString = DateFormat('EEE dd').format(date);
                      final isSelected =
                          _selectedDate != null &&
                          _selectedDate!.year == date.year &&
                          _selectedDate!.month == date.month &&
                          _selectedDate!.day == date.day;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dateString,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select start time of Service',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                itemCount: _timeOptions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final time = _timeOptions[index];
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveSlotDetails,
            child: const Text('Proceed to Checkout'),
          ),
        ),
      ),
    );
  }
}
