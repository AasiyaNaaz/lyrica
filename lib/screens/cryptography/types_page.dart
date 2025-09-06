// lib/screens/cryptography/types_page.dart

import 'package:flutter/material.dart';
import 'symmetric_page.dart';
import 'asymmetric_page.dart';
import 'common_widgets.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Types'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/b3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTypeButton(context, 'Symmetric', const SymmetricPage()),
              const SizedBox(height: 20),
              _buildTypeButton(
                  context, 'Asymmetric', const AsymmetricPage(),
                  isEnabled: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(BuildContext context, String text, Widget page,
      {bool isEnabled = true}) {
    return ElevatedButton(
      onPressed: isEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}