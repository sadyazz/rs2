import 'package:flutter/material.dart';

class ScreeningsScreen extends StatelessWidget {
  const ScreeningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4F8593).withOpacity(0.1),
              const Color(0xFF4F8593).withOpacity(0.05),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: 100,
                color: Color(0xFF4F8593),
              ),
              SizedBox(height: 24),
              Text(
                'Screenings Screen',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F8593),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Coming soon...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
