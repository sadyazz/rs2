import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:flutter/material.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Movies", Column(
      children: [
        Text("Movies placeholder"),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Back")),
      ],
    ));
  }
}