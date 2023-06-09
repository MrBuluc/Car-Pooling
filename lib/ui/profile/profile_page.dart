// ignore_for_file: use_build_context_synchronously
import 'package:car_pooling/models/user/review.dart';
import 'package:car_pooling/services/validator.dart';
import 'package:car_pooling/ui/const.dart';
import 'package:car_pooling/ui/profile/reviews_page.dart';
import 'package:car_pooling/viewmodel/user_model.dart';
import 'package:car_pooling/widgets/profile_picture.dart';
import 'package:car_pooling/widgets/progress_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../models/user/vehicle.dart';

class ProfilePage extends StatefulWidget {
  final Vehicle vehicle;
  const ProfilePage({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> userInfoFormKey = GlobalKey<FormState>(),
      vehicleInfoFormKey = GlobalKey<FormState>();

  TextEditingController nameCnt = TextEditingController(),
      surnameCnt = TextEditingController(),
      mailCnt = TextEditingController(),
      brandCnt = TextEditingController(),
      colorCnt = TextEditingController(),
      modelCnt = TextEditingController(),
      plateNoCnt = TextEditingController();

  bool userInfoChanged = false, vehicleInfoChanged = false, isProgress = false;

  String? profilePictureUrl;

  late List<TextEditingController> userInfoCntList, vehicleInfoCntList;
  List<String> userInfoLabelTextList = ["Name", "Surname", "Mail"],
      vehicleInfoLabelTextList = ["Brand", "Model", "Color", "Plate"];
  List<IconData> userInfoIconList = [
        Icons.perm_identity,
        Icons.perm_identity,
        Icons.mail
      ],
      vehicleInfoIconList = [
        Icons.directions_car,
        Icons.directions_car_filled,
        Icons.format_paint,
        Icons.abc
      ];

  late Vehicle vehicle;

  @override
  void initState() {
    super.initState();
    currentUser();
    currentVehicle();
    userInfoCntList = [nameCnt, surnameCnt, mailCnt];
    vehicleInfoCntList = [brandCnt, modelCnt, colorCnt, plateNoCnt];
  }

  currentUser() {
    User user = Provider.of<UserModel>(context, listen: false).user!;
    nameCnt.text = user.name!;
    surnameCnt.text = user.surname!;
    mailCnt.text = user.mail!;
    profilePictureUrl = user.profilePictureUrl;
  }

  currentVehicle() {
    vehicle = widget.vehicle;
    if (vehicle.brand != null) {
      brandCnt.text = vehicle.brand!;
      colorCnt.text = vehicle.color!;
      modelCnt.text = vehicle.model!;
      plateNoCnt.text = vehicle.plateNo!;
    }
  }

  @override
  void dispose() {
    nameCnt.dispose();
    surnameCnt.dispose();
    mailCnt.dispose();
    brandCnt.dispose();
    colorCnt.dispose();
    modelCnt.dispose();
    plateNoCnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: ProfilePicture(
                    imgUrl: profilePictureUrl,
                    height: 80,
                    width: 80,
                  )),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 15, bottom: 15, top: 10, right: 15),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Contact Information",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      ProgressElevatedButton(
                          isProgress: isProgress,
                          text: "Reviews",
                          backgroundColor: Colors.red,
                          onPressed: () {
                            getReviews();
                          })
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: userInfoFormKey,
                            child: Column(
                              children: buildForm(0),
                            ),
                          ),
                          Form(
                              key: vehicleInfoFormKey,
                              child: Column(
                                children: buildForm(1),
                              ))
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future getReviews() async {
    setState(() {
      isProgress = true;
    });

    try {
      List<Review> reviews =
          await Provider.of<UserModel>(context, listen: false).getReviews();

      setState(() {
        isProgress = false;
      });

      goToPage(context, ReviewsPage(reviews: reviews));
    } catch (e) {
      showSnackBar(context, e.toString(), error: true);

      setState(() {
        isProgress = false;
      });
    }
  }

  List<Widget> buildForm(int mode) {
    List<Widget> children = [];
    late String buttonText;
    late void Function() onPressed;
    if (mode == 0) {
      for (int i = 0; i < userInfoCntList.length; i++) {
        late Function validator;
        if (i == 0 || i == 1) {
          validator = Validator.textControl;
        } else {
          validator = Validator.emailControl;
        }
        children.add(buildTextFormField(userInfoCntList[i],
            userInfoLabelTextList[i], userInfoIconList[i], validator, mode,
            top: i == 0 ? 15 : 0,
            keyboardType: i == 2 ? TextInputType.emailAddress : null));
      }
      buttonText = "Contact";
      onPressed = updateUser;
    } else {
      buttonText = "Vehicle";
      for (int i = 0; i < vehicleInfoCntList.length; i++) {
        children.add(buildTextFormField(
            vehicleInfoCntList[i],
            vehicleInfoLabelTextList[i],
            vehicleInfoIconList[i],
            Validator.emptyControl,
            mode));
      }
      onPressed = addOrUpdateVehicle;
    }
    children.add(Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .65,
        child: ProgressElevatedButton(
          isProgress: isProgress,
          text: "Save $buttonText Information",
          onPressed: onPressed,
        ),
      ),
    ));
    return children;
  }

  Widget buildTextFormField(TextEditingController controller, String labelText,
          IconData icon, Function validator, int mode,
          {double top = 0, TextInputType? keyboardType}) =>
      Container(
        padding: EdgeInsets.only(top: top, left: 15, right: 30),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration:
              InputDecoration(labelText: labelText, prefixIcon: Icon(icon)),
          validator: (String? value) => validator(value, labelText),
          onChanged: (String value) =>
              mode == 0 ? userInfoChanged = true : vehicleInfoChanged = true,
        ),
      );

  Future updateUser() async {
    if (userInfoFormKey.currentState!.validate()) {
      setState(() {
        isProgress = true;
      });

      try {
        bool result = await Provider.of<UserModel>(context, listen: false)
            .updateUser(User(
                mail: mailCnt.text,
                name: nameCnt.text,
                surname: surnameCnt.text));
        if (result) {
          showSnackBar(context, "User info has been successfully updated");
        }
      } catch (e) {
        showSnackBar(context, e.toString(), error: true);
      }

      setState(() {
        isProgress = false;
      });
    } else {
      showSnackBar(context, "Enter the valid values", error: true);
    }
  }

  Future addOrUpdateVehicle() async {
    if (vehicleInfoFormKey.currentState!.validate()) {
      setState(() {
        isProgress = true;
      });

      try {
        Vehicle newVehicle = Vehicle(
            brand: brandCnt.text,
            color: colorCnt.text,
            model: modelCnt.text,
            plateNo: plateNoCnt.text);
        late bool result;
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        if (vehicle.brand == null) {
          result = await userModel.addVehicle(newVehicle);
        } else {
          newVehicle.id = vehicle.id;
          newVehicle.userId = vehicle.userId;
          result = await userModel.updateVehicle(newVehicle);
        }
        if (result) {
          showSnackBar(context, "Vehicle info has been successfully updated");
        }
      } catch (e) {
        showSnackBar(context, e.toString(), error: true);
      }

      setState(() {
        isProgress = false;
      });
    } else {
      showSnackBar(context, "Enter the valid values", error: true);
    }
  }
}
