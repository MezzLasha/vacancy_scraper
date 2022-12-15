import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SavedAdverts extends StatefulWidget {
  const SavedAdverts({super.key});

  @override
  State<SavedAdverts> createState() => _SavedAdvertsState();
}

class _SavedAdvertsState extends State<SavedAdverts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {},
      ),
    );
  }
}
