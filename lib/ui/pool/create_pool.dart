import 'package:flutter/material.dart';

class CreatePool extends StatefulWidget {
  const CreatePool({Key? key}) : super(key: key);

  @override
  State<CreatePool> createState() => _CreatePoolState();
}

class _CreatePoolState extends State<CreatePool> {
  TextEditingController placesCnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              TextFormField(
                controller: placesCnt,
                decoration: InputDecoration(border: const OutlineInputBorder()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
