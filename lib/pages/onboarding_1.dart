import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/onboarding_1.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO OOMMAA !',
                      style: GoogleFonts.righteous(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'NEED A QUICK FIX ?',
                      style: GoogleFonts.raleway(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Get expert help for home repairs, maintenance, and installations—all in one place. Book a service in seconds!',
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildDot(true),
                            _buildDot(false),
                            _buildDot(false),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/onboarding2');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB852F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 40,
                            ),
                          ),
                          child: Text(
                            'Next',
                            style: GoogleFonts.archivo(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEB852F) : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
