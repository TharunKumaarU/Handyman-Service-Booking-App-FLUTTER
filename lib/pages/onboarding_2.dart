import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/onboarding_2.png', fit: BoxFit.cover),
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
                      'Book a Service',
                      style: GoogleFonts.righteous(
                        fontSize: 27,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Select the service you need, choose a convenient time, and let us handle it with care and expertise',
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
                            _buildDot(false),
                            _buildDot(true),
                            _buildDot(false),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/onboarding3');
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
