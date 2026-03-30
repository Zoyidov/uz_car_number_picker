import 'package:flutter/material.dart';
import 'package:uz_car_number_picker/uz_car_number_picker.dart';

void main() => runApp(const MaterialApp(home: ExampleHome()));

class ExampleHome extends StatelessWidget {
  const ExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: UzCarNumberPicker(),
      ),
    );
  }
}