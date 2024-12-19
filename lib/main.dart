import 'package:flutter/material.dart';
import 'package:flutter_sudoku4/screens/sudoku_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SudokuScreen(), 
    );
  }
}