import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/widgets/DesactivateTotenModeButton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gym_app/services/attendance_service.dart';
import 'package:gym_app/services/user_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  final AttendanceService _attendanceService = AttendanceService();
  final UserService _userService = UserService();
  final int pinLength = 4;
  String _pin = '';
  List<String> _displayPin = [];
  String? userId;

  // Animation controller for pressed button effect
  late AnimationController _animationController;
  String? _lastPressedButton;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _addDigit(String digit) {
    if (_pin.length < pinLength) {
      setState(() {
        _pin += digit;
        _displayPin.add('•');
        _pinController.text = _pin;

        // Set last pressed button for animation
        _lastPressedButton = digit;
      });

      // Animate the button press
      _animationController.forward(from: 0).then((_) {
        if (mounted) {
          setState(() {
            _lastPressedButton = null;
          });
        }
      });

      // Auto submit when pin is complete
      if (_pin.length == pinLength) {
        _handlePinSubmit();
      }
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _displayPin.removeLast();
        _pinController.text = _pin;
      });
    }
  }

  void _clearPin() {
    setState(() {
      _pin = '';
      _displayPin.clear();
      _pinController.text = '';
    });
  }

  Future<void> _handlePinSubmit() async {
    if (_pin.length < pinLength) {
      _showMessage("El PIN debe tener $pinLength dígitos.");
      return;
    }
    try {
      // Check in with PIN and get response
      final response = await _attendanceService.checkInWithPin(_pin);

      if (!response['success']) {
        _showMessage(response['message']);
        _clearPin();
        return;
      }

      // Get the userId from the response
      final userId = response['userId'];

      // Then fetch the user's name
      final userName = await _userService.getUserName(userId);
      final displayName =
          userName ?? 'Usuario'; // Show success animation with user's name
      // Check if there's a subscription warning
      String welcomeMessage = "¡Bienvenido/a, $displayName!";
      if (response.containsKey('warning')) {
        welcomeMessage += "\n${response['warning']}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  welcomeMessage,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor:
              response.containsKey('warning') ? Colors.orange : Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );

      // Clear the PIN after success
      _clearPin();
    } catch (e) {
      // Check if the error is due to already checked in today
      if (e.toString().contains('Ya registraste tu asistencia hoy')) {
        _showMessage("Ya registraste tu asistencia hoy.");
      } else {
        _showMessage("Error al verificar PIN: ${e.toString()}");
      }
      _clearPin();
    }
  } // Function to get current user's ID using the service

  Future<void> _fetchCurrentUserId() async {
    try {
      final String? currentUserId = _userService.getCurrentUserId();

      if (currentUserId != null) {
        setState(() {
          userId = currentUserId;
        });
      } else {
        _showMessage("No hay usuario autenticado");
      }
    } catch (e) {
      _showMessage("Error al obtener usuario: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  // Only using square button builders

  // Square button builders
  Widget _buildSquareButton(String number, double size) {
    final isPressed = _lastPressedButton == number;

    return GestureDetector(
      onTap: () => _addDigit(number),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final scale =
              isPressed ? 1.0 - (_animationController.value * 0.1) : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Square with slightly rounded corners
                color: Colors.transparent,
                border: Border.all(color: const Color(0xFFFF8C42), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFFFF8C42,
                    ).withOpacity(isPressed ? 0.2 : 0.3),
                    spreadRadius: isPressed ? 0 : 1,
                    blurRadius: isPressed ? 2 : 4,
                    offset: isPressed ? const Offset(0, 1) : const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: size * 0.5, // Larger responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSquareFunctionButton(
    IconData icon,
    double size,
    VoidCallback onPressed,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        onPressed();
        _animationController.forward(from: 0);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8,
              ), // Square with slightly rounded corners
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFFFF8C42), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8C42).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: size * 0.5, // Larger responsive icon size
                color: const Color(0xFFFF8C42),
              ),
            ),
          );
        },
      ),
    );
  }

  // No QR code scanning functionality
  @override
  Widget build(BuildContext context) {
    // Calculate responsive dimensions for 2560x1600 resolution
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    // Calculate responsive button sizes - making them fit without scrolling
    final buttonSize =
        (screenWidth * 0.24) / 3; // Smaller size to ensure no scrolling
    final pinBoxSize =
        screenWidth * 0.05; // Slightly smaller PIN boxes to fit everything

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A), // Dark background
        body: Stack(
          children: [
            // Background overlay with subtle gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.black, const Color(0xFF212121)],
                ),
              ),
            ),
            // Using a non-scrollable container to fit everything on screen
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [
                  // App Logo and Header area
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset(
                    'assets/gym_logo.png',
                    height: screenHeight * 0.08,
                  ),
                  const SizedBox(height: 10),

                  // Simplified large title "CHECK-IN"
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CHECK-IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60, // Much larger text
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ingrese su PIN o escanee el código QR desde el App',
                    style: TextStyle(color: Colors.white70, fontSize: 24),
                  ), // Dedicated QR Code Area - Always showing QR for clients to scan
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.25,
                    ),
                    padding: EdgeInsets.all(15),
                    height:
                        screenHeight *
                        0.25, // Slightly smaller height to avoid scrolling
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFFF8C42),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8C42).withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            width: screenHeight * 0.20,
                            height: screenHeight * 0.20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(8),
                            child: QrImageView(
                              data: userId ?? 'Usuario no identificado',
                              version: QrVersions.auto,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Color(0xFFFF8C42),
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black,
                              ),
                              errorStateBuilder: (ctx, err) {
                                return const Center(
                                  child: Text(
                                    "Error al generar el QR",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // PIN Display with 4 distinct boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(pinLength, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ), // Slightly reduced margin
                          width: pinBoxSize,
                          height: pinBoxSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Square boxes with rounded corners
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFFF8C42),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF8C42).withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                index < _displayPin.length
                                    ? Text(
                                      "•",
                                      style: TextStyle(
                                        fontSize: pinBoxSize * 0.6,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF8C42),
                                      ),
                                    )
                                    : null,
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03), // Reduced spacing
                  // Number Pad with square buttons - optimized spacing to avoid scrolling
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSquareButton('1', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('2', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('3', buttonSize),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ), // Smaller spacing to avoid scrolling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSquareButton('4', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('5', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('6', buttonSize),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ), // Smaller spacing to avoid scrolling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSquareButton('7', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('8', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('9', buttonSize),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ), // Smaller spacing to avoid scrolling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSquareFunctionButton(
                            Icons.backspace,
                            buttonSize,
                            _removeDigit,
                            const Color(0xFFFF8C42),
                          ),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareButton('0', buttonSize),
                          const SizedBox(
                            width: 25,
                          ), // Reduced spacing to avoid scrolling
                          _buildSquareFunctionButton(
                            Icons.clear,
                            buttonSize,
                            _clearPin,
                            const Color(0xFFFF8C42),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ), // Reduced bottom padding
                ],
              ),
            ),

            // Botón de salir del modo tóten
            Positioned(top: 24, right: 16, child: DesactivateTotenModeButton()),
          ],
        ),
      ),
    );
  }
}
