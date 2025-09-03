import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpDialogs {
  // Step-by-step tutorial content
  static final List<Widget> steps = [
    // Step 1: Overview / Disaster Example
    RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 43, 0, 69),
        ),
        children: [
          const TextSpan(
            text: "Avoiding Resonance Disasters\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextSpan(text: "The infamous "),
          const TextSpan(
            text: "Tacoma Narrows Bridge (1940)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: " twisted itself apart because wind gusts hit near its ",
          ),
          const TextSpan(
            text: "natural frequency",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text:
                ". Engineers now design buildings so their natural frequencies don’t match expected seismic waves. Heavier or more flexible structures have lower frequencies. Skyscrapers sway but are tuned to avoid resonance.\n\n",
          ),
          const TextSpan(
            text: "Mini Demo Idea: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: "[Add simple animation of a swaying bridge or swing]",
          ),
        ],
      ),
    ),

    // Step 2: Natural Frequency
    RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 43, 0, 69),
        ),
        children: [
          const TextSpan(
            text: "What is Natural Frequency?\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextSpan(text: "Natural frequency is the "),
          const TextSpan(
            text: "preferred rhythm of vibration",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text:
                " of an object. Think of pushing someone on a swing—if you push at the right rhythm, they swing higher with minimal effort. This is exactly what happens in resonance.",
          ),
        ],
      ),
    ),

    // Step 3: Materials and Frequency
    RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 43, 0, 69),
        ),
        children: [
          const TextSpan(
            text: "How Materials Affect Frequency\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextSpan(text: "Materials influence vibration based on their "),
          const TextSpan(
            text: "stiffness",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: " and "),
          const TextSpan(
            text: "density",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text:
                ":\n\n- Stiffer materials → higher frequency\n- Heavier materials → lower frequency\n\n",
          ),
          const TextSpan(
            text: "Formula Hint: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: "f ∝ √(E/ρ)\n\nSteel has higher frequency than concrete.",
          ),
        ],
      ),
    ),

    // Step 4: Why Construction Cares
    RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 43, 0, 69),
        ),
        children: [
          const TextSpan(
            text: "Why This Matters in Construction\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextSpan(text: "- Matching frequencies = "),
          const TextSpan(
            text: "danger (resonance)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text:
                "\n- Mismatched frequencies = damping (vibration energy spreads out)\n- Engineers deliberately separate structural frequencies from expected disturbances like wind, footsteps, or earthquakes.\n\n",
          ),
        ],
      ),
    ),

    // Step 5: Gameplay Instructions
    RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 43, 0, 69),
        ),
        children: [
          const TextSpan(
            text: "How the Game Works\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const TextSpan(
            text:
                "• You will be given materials to construct a monument.\n"
                "• Each material has its own natural frequency, and changes may occur during construction.\n"
                "• Disturbances will test your structure against natural disasters.\n"
                "• Goal: Build a safe, stable structure by avoiding resonance and mismatched frequencies.\n\n",
          ),
          const TextSpan(
            text: "Tip: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text:
                "Observe the frequency values carefully and pair materials wisely.",
          ),
        ],
      ),
    ),
  ];

  // Show dialog sequence
  static void showHelpDialog(BuildContext context, [int index = 0]) {
    if (index >= steps.length) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 246, 200, 255),
        content: SingleChildScrollView(child: steps[index]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showHelpDialog(context, index + 1);
            },
            style: TextButton.styleFrom(
              foregroundColor: Color.fromARGB(
                255,
                43,
                0,
                69,
              ), // This changes the text color
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ), // optional styling
            ),
            child: Text(index == steps.length - 1 ? "Finish" : "Next"),
          ),
        ],
      ),
    );
  }

  // Check for first-time launch
  static Future<void> checkFirstTime(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time_help') ?? true;

    if (firstTime) {
      prefs.setBool('first_time_help', false);
      showHelpDialog(context);
    }
  }
}
