import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Page'),
      ),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: Text(
            'Recommendation Page',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
