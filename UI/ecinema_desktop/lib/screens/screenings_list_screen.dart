import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class ScreeningsListScreen extends StatelessWidget {
  const ScreeningsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Screenings", Column(
      children: [
        Text("Screenings placeholder"),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: (){}, child: Text("Back")),
      ],
    ));
  }
}