// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/home_page/home_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  TextStyle textStyle = const TextStyle(fontSize: 20);

  bool isProgress = false;

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
                ProgressElevatedButton(
                    isProgress: isProgress,
                    text: "Hakkıcan",
                    onPressed: () {
                      goToPage("KGd2I6yOP8Vo6hwU6gj7DuvuZpO2");
                    }),
                ProgressElevatedButton(
                    isProgress: isProgress,
                    text: "Alex",
                    onPressed: () {
                      goToPage("G3mevApBThgNDz7Nq0EuuQhVMjz1");
                    })
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ProgressElevatedButton(
                isProgress: isProgress,
                text: "Emily",
                onPressed: () {
                  goToPage("EC2mQSpeZPckbi6GTvVaqMcaKmZ2");
                })
          ],
        ),
      ),
    );
  }

  goToPage(String userId) async {
    setState(() {
      isProgress = true;
    });

    try {
      await Provider.of<UserModel>(context, listen: false).getUser(userId);

      setState(() {
        isProgress = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);
    }
  }
}
