// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ui/const.dart';
import '../ui/profile/account_page.dart';
import '../viewmodel/user_model.dart';

class ViewProfileButton extends StatefulWidget {
  final String userId;
  const ViewProfileButton({Key? key, required this.userId}) : super(key: key);

  @override
  State<ViewProfileButton> createState() => _ViewProfileButtonState();
}

class _ViewProfileButtonState extends State<ViewProfileButton> {
  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return ProgressElevatedButton(
        isProgress: isProgress,
        text: "View Profile",
        onPressed: () {
          getProfile(widget.userId);
        });
  }

  Future getProfile(String userId) async {
    setState(() {
      isProgress = true;
    });

    try {
      List userAndVehicle = await Provider.of<UserModel>(context, listen: false)
          .getProfile(userId);

      setState(() {
        isProgress = false;
      });

      goToPage(
          context,
          AccountPage(
            user: userAndVehicle[0],
            vehicle: userAndVehicle[1],
          ));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }
}
