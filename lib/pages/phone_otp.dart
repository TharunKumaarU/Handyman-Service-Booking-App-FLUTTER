import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneOtpPage extends StatefulWidget {
  const PhoneOtpPage({super.key});

  @override
  State<PhoneOtpPage> createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends State<PhoneOtpPage> {
  final TextEditingController otpController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  // Will come from arguments
  String? verificationId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      verificationId = args['verificationId'] as String?;
      debugPrint('Received verificationId: $verificationId');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    final smsCode = otpController.text.trim();
    if (verificationId == null || smsCode.isEmpty) {
      setState(() {
        errorMessage = 'Please enter the OTP.';
        isLoading = false;
      });
      return;
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone verified successfully')),
      );
      final userPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
      if (!mounted) return;
      if (userPhone != null) {
        Navigator.pushReplacementNamed(
          context,
          '/address',
          arguments: userPhone,
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.message ?? 'Invalid OTP';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'OTP'),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
