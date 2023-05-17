// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  final String item;

  const ComingSoon({Key? key, required this.item}) : super(key: key);

  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(251, 247, 10, 46),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/indus-logo.png',
                width: 120,
              ),
              const SizedBox(
                width: 40,
              ),
              const Text(
                "ICON 2024",
                style: TextStyle(fontWeight: FontWeight.w900),
              )
            ],
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Coming Soon"),
            Text(widget.item),
          ],
        ),
      ),
    );
  }
}
