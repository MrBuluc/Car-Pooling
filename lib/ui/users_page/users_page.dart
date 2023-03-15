import 'package:car_pooling/ui/home_page/home_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextStyle textStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    "Hakkıcan",
                    style: textStyle,
                  ),
                  onPressed: () {
                    goToPage("KGd2I6yOP8Vo6hwU6gj7DuvuZpO2", "Hakkıcan Bülüç");
                  },
                ),
                ElevatedButton(
                  child: Text(
                    "Berat",
                    style: textStyle,
                  ),
                  onPressed: () {
                    goToPage(
                        "G3mevApBThgNDz7Nq0EuuQhVMjz1", "beratcan Duğancı");
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text("süleyman", style: textStyle),
              onPressed: () {
                goToPage("EC2mQSpeZPckbi6GTvVaqMcaKmZ2", "süleyman ismail");
              },
            )
          ],
        ),
      ),
    );
  }

  goToPage(String userId, String username) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.userId = userId;
    userModel.username = username;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  }
}
