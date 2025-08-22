import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: InteractiveViewer(
          panEnabled: true, // Can drag to move
          minScale: 1.0,
          maxScale: 5.0, // Set your zoom range
          child: Image.asset(
            'assets/agra-metro-map.jpg',
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

}