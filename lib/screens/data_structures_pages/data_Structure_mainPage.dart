import 'package:flutter/material.dart';
import 'package:lyrica/screens/data_structures_pages/Trees.dart';
import 'package:lyrica/screens/data_structures_pages/linkedLIst.dart';
import 'package:lyrica/screens/data_structures_pages/merging_arrays_page.dart';
import 'package:lyrica/screens/data_structures_pages/sorting_page.dart';
import 'package:lyrica/screens/data_structures_pages/stack_page.dart';

class HomePage1 extends StatelessWidget {
  final List<Map<String, dynamic>> dataStructures = [
    {
      "title": "Linked List",
      "subtitle": "Visualize linked list",
      "color": Colors.purple.withOpacity(0.25),
      "page": LinkedListIntroPage(),
    },
    {
      "title": "Trees",
      "subtitle": "Explore tree structures",
      "color": Colors.green.withOpacity(0.25),
      "page": TreeMusicPage(),
    },
    {
      "title": "Merge Array",
      "subtitle": "Learn merging arrays",
      "color": Colors.pink.withOpacity(0.25),
      "page": MergingArraysPage(),
    },
    {
      "title": "Graphs",
      "subtitle": "Coming soon",
      "color": Colors.teal.withOpacity(0.25),
      "page": null,
    },
    {
      "title": "Stacks",
      "subtitle": "Visualize stack behavior",
      "color": Colors.orange.withOpacity(0.25),
      "page": StackPage(),
    },
    {
      "title": "Sorting Arrays",
      "subtitle": "Learn queue operations",
      "color": Colors.blue.withOpacity(0.25),
      "page":SortingPage(),
    },
  ];

  Widget buildDataStructureButton(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        if (item["page"] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item["page"]),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${item['title']} feature coming soon!"),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: item["color"],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: item["color"]!.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item["subtitle"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 12, 29, 65), // Blue
              Color.fromARGB(255, 53, 25, 97), // Purple
              Color.fromARGB(255, 126, 69, 137), // Pink
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Data Structures",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2, // adjusted to fit text better
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  children: dataStructures
                      .map((item) => buildDataStructureButton(context, item))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
