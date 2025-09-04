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

//after level learning
Future<void> showLearningDialogs(BuildContext context) async {
  final List<Map<String, String>> dialogs = [
    {
      "title": "✨ The Resonance Trap",
      "icon": "🎵",
      "content":
          "Ever tried singing in the bathroom and the walls suddenly vibe with you? "
          "That’s resonance!\n\n"
          "When materials like wood or brick face disturbances at their natural frequency, "
          "the vibrations get amplified like a speaker turned up too high. "
          "Bigger shakes → bigger trouble → sometimes even collapse.",
    },
    {
      "title": "🧱 Stack Attack",
      "icon": "📦",
      "content":
          "Stacking materials of the same frequency? Think of it like stacking speakers "
          "blasting the same bass beat—LOUDER and stronger!\n\n"
          "When similar frequencies pile up in a structure, the overall frequency gets boosted "
          "(ignoring other construction soup ingredients).",
    },
    {
      "title": "🎹 The Piano Test",
      "icon": "🎼",
      "content":
          "To make this less boring than an engineering textbook, let’s match frequencies "
          "with piano notes.\n\n"
          "• Wood → higher pitch than brick 🌳\n"
          "• Brick → lower pitch 🧱\n\n"
          "🌪️ Wind usually plays in the 1–5 Hz band → if your structure lands there → bye-bye building!\n\n"
          "🌍 Earthquakes jam harder at 6–7 Hz → unlucky if your design sings in that range.",
    },
    {
      "title": "🏗️ Brick vs. Wood: The Survival Game",
      "icon": "⚔️",
      "content":
          "Since wood naturally has a higher frequency than brick, it’s like the older sibling "
          "who can’t be pushed around easily.\n\n"
          "That means: you need MORE levels of brick than wood to escape the dangerous frequency "
          "bands of wind and earthquakes.\n\n"
          "Moral: pick your blocks wisely, or nature will remix your building into rubble.",
    },
  ];

  // Sequentially show all dialogs
  for (int i = 0; i < dialogs.length; i++) {
    await showDialog(
      context: context,
      barrierDismissible: false, // must press button
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 202, 153, 255), Color.fromARGB(255, 155, 191, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(5, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with icon
              Row(
                children: [
                  Text(
                    dialogs[i]["icon"]!,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dialogs[i]["title"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Content
              SingleChildScrollView(
                child: Text(
                  dialogs[i]["content"]!,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Next button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  i == dialogs.length - 1 ? "🚀 Next Level" : "Next →",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showLevel2LearningDialogs(BuildContext context) async {
  final List<Map<String, String>> dialogs = [
    {
      "title": "🛠️ Side-by-Side Secrets",
      "icon": "🔗",
      "content":
          "In Level 2, you learned that the order of your blocks doesn’t affect the overall natural frequency when materials are placed side by side. "
          "Think of it like a team of dancers — whether steel leads or wood does, the rhythm of the dance floor stays the same! 🎵"
          "\n\nSo stacking different materials doesn’t magically change the frequency — you’ve got to choose wisely."
    },
    {
      "title": "📊 Frequency Hierarchy",
      "icon": "⚡",
      "content":
          "Remember the natural frequency order:\n\n"
          "• Steel → highest 🏋️‍♂️\n"
          "• Wood → medium 🌳\n"
          "• Brick → lowest 🧱\n\n"
          "This matters because:\n"
          "• Human footstep vibrations? Wood and Steel shrug them off. 🦶😎\n"
          "• Wind? Only Steel can stand tall. 🌬️💪\n\n"
          "Moral: sometimes being too light (or too heavy) can get your bridge in trouble!"
    },
    {
      "title": "🌪️ Surviving the Elements",
      "icon": "🛡️",
      "content":
          "In this level, you learned that **Wind is a big bully** — it destroys Wood and Brick, but Steel flexes like a superhero cape and survives.\n"
          "Human footsteps are more like tickles — Brick takes the hit, Wood and Steel barely notice.\n\n"
          "The challenge? Choose the right material to match the disaster, because brute force alone won’t save your bridge!"
    },
    {
      "title": "🎯 Strategy Tips",
      "icon": "🧠",
      "content":
          "• Side-by-side placement won’t save you — focus on the material choice! \n"
          "• Steel is your Wind superhero 🦸‍♂️. \n"
          "• Wood is reliable against foot traffic, but Wind will mess it up 🌬️🌳. \n"
          "• Brick is the underdog — watch your step 🧱⚡.\n\n"
          "Think like an engineer, not a gambler. Predict, plan, and place your blocks wisely!"
    },
    {
      "title": "✨ Fun Fact",
      "icon": "🎹",
      "content":
          "Just like piano keys, each material has its own pitch. Steel sings the highest note, Wood hums in the middle, and Brick groans the lowest.\n"
          "If the disaster hits at the same frequency as your bridge's note… well, let’s just say the music stops abruptly! 🎵💥\n\n"
          "Remember: winning isn’t just about building tall — it’s about **building smart**!"
    },
  ];

  // Sequentially show all dialogs
  for (int i = 0; i < dialogs.length; i++) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 155, 191, 255), Color.fromARGB(255, 202, 153, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(5, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with icon
              Row(
                children: [
                  Text(
                    dialogs[i]["icon"]!,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dialogs[i]["title"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Content
              SingleChildScrollView(
                child: Text(
                  dialogs[i]["content"]!,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Next button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.deepPurpleAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  i == dialogs.length - 1 ? "🚀 Next Level" : "Next →",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
