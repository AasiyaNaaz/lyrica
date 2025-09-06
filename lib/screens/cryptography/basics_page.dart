// lib/screens/cryptography/basics_page.dart

import 'package:flutter/material.dart';
import 'key_terms_page.dart';
import 'types_page.dart';
import 'encryption_page.dart';
import 'common_widgets.dart';

class BasicsPage extends StatelessWidget {
  const BasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Basics'),
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
            image: AssetImage('assets/images/b3.jpg'), // b3.jpg for main pages
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLessonButton(context, 'Keyterms', const KeyTermsPage()),
              const SizedBox(height: 20),
              _buildLessonButton(context, 'Encryption/Decryption', const EncryptionPage()),
              const SizedBox(height: 20),
              _buildLessonButton(context, 'Types', const TypesPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
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