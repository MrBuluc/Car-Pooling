import 'package:car_pooling/widgets/profile_picture.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';

import '../../models/user/user.dart';
import '../../models/user/vehicle.dart';

class AccountPage extends StatefulWidget {
  final User user;
  final Vehicle? vehicle;
  const AccountPage({Key? key, required this.user, this.vehicle})
      : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late User user;

  late Vehicle? vehicle;

  late Size size;

  TextStyle textStyle = TextStyle(
      color: Colors.grey.shade900,
      fontFamily: "Catamaran",
      fontSize: 18,
      fontWeight: FontWeight.bold);

  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    vehicle = widget.vehicle;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          buildHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ProgressElevatedButton(
              isProgress: isProgress,
              text: "Reviews",
              backgroundColor: Colors.red,
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeader() => SizedBox(
        height: size.height * .7,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * .33,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfilePicture(
                      imgUrl: user.profilePictureUrl, width: 150, height: 150)
                ],
              ),
            ),
            Positioned(
              top: size.height * .3,
              right: size.width * .1,
              left: size.width * .1,
              child: Container(
                height: size.height * .4,
                width: size.width * .6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, bottom: 10, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${user.name}",
                        style: textStyle,
                      ),
                      Text(
                        "Surname: ${user.surname}",
                        style: textStyle,
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Text(
                        "Brand: ${nullCheck(vehicle?.brand)}",
                        style: textStyle,
                      ),
                      Text(
                        "Model: ${nullCheck(vehicle?.model)}",
                        style: textStyle,
                      ),
                      Text(
                        "Color: ${nullCheck(vehicle?.color)}",
                        style: textStyle,
                      ),
                      Text(
                        "PlateNo: ${nullCheck(vehicle?.plateNo)}",
                        style: textStyle,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

  String nullCheck(String? value) => value ?? "";
}
