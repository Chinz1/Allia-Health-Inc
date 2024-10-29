import 'package:allia_health_inc_test_app/gen/assets.gen.dart';
import 'package:allia_health_inc_test_app/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

class SelfReportCompletedScreen extends StatelessWidget {
  const SelfReportCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: const Color(0xFFF9F7F3), // Scaffold background color
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the whole screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/self_report_completed.png', // Path to your image
              width: 224,
              height: 224,
            ),
            const SizedBox(height: 8),
            const Text(
              'Self report completed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            const SizedBox(
                height: 20), // Space between the image and the button
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeScreen when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E959E), // Button color
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0, // Vertical padding inside the button
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
              child: const SizedBox(
                width: double.infinity, // Full width button
                child: Center(
                  child: Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white, // Button text color
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Space between button and bottom
          ],
        ),
      ),
    );
  }
}
