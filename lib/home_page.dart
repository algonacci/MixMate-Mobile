import 'package:flutter/material.dart';
import 'package:mixmate_mobile/button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/recommendation");
                },
                child: const Button(
                  text: "Rekomendasi OOTD",
                  icon: Icons.compost,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
