import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double size;
  const MyBarrier({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 5,
          color: Colors.green,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.green[600],
      ),
    );
  }
}
