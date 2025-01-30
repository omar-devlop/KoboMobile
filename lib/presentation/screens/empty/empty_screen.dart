import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empty screen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Just an empty screen :)'),
      ),
    );
  }
}
