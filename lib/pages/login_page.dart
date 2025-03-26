import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fba;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? errorMessage;

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    final nav = Navigator.of(context);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled the sign-in flow
        setState(() => isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      nav.pushReplacementNamed('/address');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithFacebook() async {
    setState(() => isLoading = true);
    final nav = Navigator.of(context);
    try {
      final result = await fba.FacebookAuth.instance.login();
      if (result.status == fba.LoginStatus.success) {
        final accessToken = result.accessToken!;
        // Use tokenString if 'token' isn't available in your version
        final credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (!mounted) return;
        nav.pushReplacementNamed('/address');
      } else {
        setState(() {
          errorMessage = result.message;
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Optional background image
          Positioned.fill(
            child: Image.asset('assets/login_bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/app_logo.png', height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'OOMMAA HANDYMAN SERVICES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Reliable Fixes, Right at your Door Steps!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  const SizedBox(height: 10),
                  // Google Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Image.asset('assets/google_logo.png', height: 24),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Facebook Sign-In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _signInWithFacebook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.facebook, size: 24),
                      label: const Text(
                        'Continue with Facebook',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
