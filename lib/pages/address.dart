import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // OTP flow
  bool _otpSent = false;
  bool _otpVerified = false;
  String _verificationId = '';

  // Country code defaults to UAE (+971)
  String _selectedCountryCode = '+971';

  // Map
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final CameraPosition _defaultCameraPosition = const CameraPosition(
    target: LatLng(25.2048, 55.2708), // Dubai
    zoom: 14,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If phone number was passed from a previous page, pre-fill the field
    final phoneFromOtp = ModalRoute.of(context)?.settings.arguments as String?;
    if (phoneFromOtp != null && phoneFromOtp.isNotEmpty) {
      if (phoneFromOtp.startsWith('+971')) {
        _selectedCountryCode = '+971';
        _mobileController.text = phoneFromOtp.replaceFirst('+971', '').trim();
      } else {
        _mobileController.text = phoneFromOtp;
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    _areaController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  /// Send OTP using Firebase Phone Auth
  Future<void> _sendOTP() async {
    final messenger = ScaffoldMessenger.of(context);
    final phoneNumber = _mobileController.text.trim();
    if (phoneNumber.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number first.")),
      );
      return;
    }

    setState(() => _otpSent = true);

    final formattedPhoneNumber = _selectedCountryCode + phoneNumber;

    // We capture a local reference to "this" in case we need to check "mounted" in the callbacks
    final currentState = this;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            if (!currentState.mounted) return;
            currentState.setState(() => _otpVerified = true);
            messenger.showSnackBar(
              const SnackBar(
                content: Text("Phone number automatically verified!"),
              ),
            );
          } catch (e) {
            if (!currentState.mounted) return;
            messenger.showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!currentState.mounted) return;
          currentState.setState(() => _otpSent = false);
          messenger.showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          if (!currentState.mounted) return;
          messenger.showSnackBar(
            SnackBar(content: Text("OTP sent to $formattedPhoneNumber")),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text("Error sending OTP: $e")));
      setState(() => _otpSent = false);
    }
  }

  Future<void> _resendOTP() async {
    await _sendOTP();
  }

  Future<void> _verifyOTP() async {
    final messenger = ScaffoldMessenger.of(context);
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Please enter the OTP.")),
      );
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      if (!mounted) return;
      setState(() => _otpVerified = true);
      messenger.showSnackBar(
        const SnackBar(content: Text("OTP verified successfully!")),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text("Invalid OTP: ${e.message}")),
      );
    }
  }

  /// Get current location
  Future<void> _determinePosition() async {
    final messenger = ScaffoldMessenger.of(context);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Location permissions are permanently denied."),
        ),
      );
      return;
    }

    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    if (!mounted) return;
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Move the map camera
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 16),
        ),
      );
    }
  }

  Widget _buildMap() {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (LatLng tappedLocation) {
          setState(() {
            _currentPosition = tappedLocation;
          });
        },
        initialCameraPosition:
            _currentPosition != null
                ? CameraPosition(target: _currentPosition!, zoom: 16)
                : _defaultCameraPosition,
        markers: {
          if (_currentPosition != null)
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: _currentPosition!,
              draggable: true,
              onDragEnd: (LatLng newPosition) {
                setState(() {
                  _currentPosition = newPosition;
                });
              },
            ),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Address'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name field
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Country code + Mobile input
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (country) {
                      setState(() {
                        _selectedCountryCode = country.dialCode ?? '+971';
                      });
                    },
                    initialSelection: 'AE',
                    favorite: const ['+971', 'AE'],
                    showCountryOnly: false,
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: 'Enter your mobile number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mobile number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // OTP section
              if (!_otpSent)
                ElevatedButton(
                  onPressed: _sendOTP,
                  child: const Text("Send OTP"),
                )
              else ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    hintText: '6-digit OTP',
                  ),
                ),
                const SizedBox(height: 16),
                if (!_otpVerified) ...[
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text("Verify OTP"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _resendOTP,
                    child: const Text("Resend OTP"),
                  ),
                ],
              ],
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Use my location for the service',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildMap(),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _determinePosition,
                child: const Text("Detect My Location"),
              ),
              const SizedBox(height: 32),
              const Divider(),

              // Address fields
              TextFormField(
                controller: _houseController,
                enabled: _otpVerified,
                decoration: const InputDecoration(
                  labelText: 'House / Flat',
                  hintText: 'Enter your house or flat number',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'House/Flat is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apartmentController,
                enabled: _otpVerified,
                decoration: const InputDecoration(
                  labelText: 'Apartment',
                  hintText: 'Enter apartment name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Apartment is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                enabled: _otpVerified,
                decoration: const InputDecoration(
                  labelText: 'Area',
                  hintText: 'Enter your area',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Area is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pinController,
                enabled: _otpVerified,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pin Code',
                  hintText: 'Enter your pin code',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pin Code is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (!_otpVerified) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Please verify your mobile number first."),
                  ),
                );
                return;
              }

              // Validate the form fields
              if (!_formKey.currentState!.validate()) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Please fill all required fields."),
                  ),
                );
                return;
              }

              // Check if location is detected
              if (_currentPosition == null) {
                messenger.showSnackBar(
                  const SnackBar(content: Text("Please detect your location.")),
                );
                return;
              }

              // Combine country code + phone
              final mobileKey =
                  _selectedCountryCode + _mobileController.text.trim();
              bool errorOccurred = false;

              try {
                await FirebaseFirestore.instance
                    .collection('address')
                    .doc(mobileKey)
                    .set({
                      'fullName': _fullNameController.text,
                      'mobile': mobileKey,
                      'house': _houseController.text,
                      'apartment': _apartmentController.text,
                      'area': _areaController.text,
                      'pin': _pinController.text,
                      'location': {
                        'latitude': _currentPosition!.latitude,
                        'longitude': _currentPosition!.longitude,
                      },
                    }, SetOptions(merge: true));
              } catch (e) {
                errorOccurred = true;
                messenger.showSnackBar(
                  SnackBar(content: Text("Error saving data: $e")),
                );
              }

              if (!mounted) return;
              if (!errorOccurred) {
                nav.pushReplacementNamed('/home', arguments: mobileKey);
              }
            },
            child: const Text('Save and home'),
          ),
        ),
      ),
    );
  }
}
