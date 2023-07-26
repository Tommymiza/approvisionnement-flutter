import 'package:flutter/material.dart';

class ChipCustom extends StatelessWidget {
  final bool isSelected;
  final String prod;
  final VoidCallback tap;
  const ChipCustom({super.key, required this.prod, required this.isSelected, required this.tap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyan[700] : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 226, 226, 226),
              blurRadius: 5.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0, // Move to right 5  horizontally
                0, // Move to bottom 5 Vertically
              ),
            ),
          ],
        ),
        child: Text(
          prod,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
    );
  }
}
