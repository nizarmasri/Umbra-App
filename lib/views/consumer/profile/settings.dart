import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/controllers/consumer/profile/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import '../../authentication/authentication_service.dart';
import 'package:events/globals.dart' as globals;
import 'package:get/get.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
        () => StreamBuilder(
          stream: controller.fetchUser.value,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: globals.spinner);
            }

            final data = snapshot.data as DocumentSnapshot;

            return Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.black,
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                      Duration(
                        seconds: 1,
                      ),
                      () => controller.fetchUser.refresh());
                },
                child: ListView(children: [
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 40, right: 10, bottom: 20),
                            decoration: BoxDecoration(),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.brown.shade800,
                                    backgroundImage: data['dp'] != ''
                                        ? NetworkImage(data['dp'])
                                        : null,
                                    child: Text(
                                      data['dp'] == ''
                                          ? data["name"][0]
                                              .toString()
                                              .toUpperCase()
                                          : '',
                                      style: TextStyle(fontSize: 50),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["name"],
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.white),
                                    ),
                                    Text(
                                      data["email"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller
                                          .navigateToProfilePage(context, snapshot),
                                      child: Text(
                                        "View Account",
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                setting(
                                  title: "Saved",
                                  icon: Icons.bookmark_outline,
                                  onTap: () =>
                                      controller.navigateToBookmark(context),
                                ),
                                setting(
                                    title: "Account Information",
                                    icon: Icons.account_circle_rounded,
                                    onTap: () => controller
                                        .navigateToEditProfilePage(context)),
                                setting(
                                  title: "About",
                                  icon: Icons.contact_mail,
                                ),
                                setting(
                                  title: "Guidelines",
                                  icon: Icons.rule,
                                ),
                                setting(
                                  title: "Report",
                                  icon: Icons.report,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              bottomNavigationBar: Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.85,
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: ProgressButton(
                    stateWidgets: {
                      ButtonState.idle: Text(
                        "Log out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                      ),
                      ButtonState.loading: Text(
                        "loading...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                      ),
                      ButtonState.success: Text(
                        "Logged out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                      ),
                      ButtonState.fail: Text(
                        "failed",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: globals.montserrat,
                            fontWeight: globals.fontWeight),
                      ),
                    },
                    stateColors: {
                      ButtonState.loading: Colors.white12,
                      ButtonState.idle: Colors.black,
                      ButtonState.success: Colors.green,
                      ButtonState.fail: Colors.red
                    },
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                  )),
            );
          }),
    );
  }

  InkWell setting(
      {required String title, IconData? icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 15, 25, 15),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text(title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
