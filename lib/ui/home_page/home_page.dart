import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/ui/pool/create_pool.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text("Yolculuk Oluştur"),
              onPressed: () {
                goToPage(const CreatePool(
                  role: Role.driver,
                ));
              },
            ),
            ElevatedButton(
              child: const Text("Yolculuk Ara"),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  goToPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
