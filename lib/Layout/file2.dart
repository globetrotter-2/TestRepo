import 'package:flutter/material.dart';
class botnav extends StatefulWidget {
  const botnav({super.key});

  @override
  State<botnav> createState() => _botnavState();
}

class _botnavState extends State<botnav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation Bar"),
        centerTitle: true,
      ),
    );
  }
}
