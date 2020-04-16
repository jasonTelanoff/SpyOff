import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name = 'Jason';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name),),
    );
  }
}