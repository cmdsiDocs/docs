// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  const CustomDialog(
      {this.message,
      this.onWillPop = true,
      this.onTap,
      this.title,
      this.onTapCancel,
      this.context,
      this.isYesNo = false});

  final String? message;
  final bool onWillPop;
  final VoidCallback? onTap;
  final String? title;
  final VoidCallback? onTapCancel;
  final bool isYesNo;
  final BuildContext? context;

  // Future<void> success() async =>
  //     myDialog('assets/images/success.png', 'Success', Message.success);
  // Future<void> confirmation() async =>
  //     myDialog('assets/images/error.png', 'Confirmation', Message.confirm);
  // Future<void> error() async =>
  //     myDialog('assets/images/error.png', 'luvpark', Message.error);
  // Future<void> serverError() async => myDialog(
  //     'assets/images/servererror.png', 'Server Error', Message.serverError);
  // Future<void> noInternet() async => myDialog('assets/images/nointernet.png',
  //     'No Internet Connection', Message.noInternet);

  Future<void> loadingDialog() async => showDialog(
        context: context ?? Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: onWillPop,
          child: ColoredBox(
            color: Colors.white.withOpacity(0.2),
            child: Center(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );

  // Future<void> myDialog(String image, String defTitle, String msg) async {
  //   showDialog(
  //     context: Get.context!,
  //     barrierDismissible: onWillPop,
  //     barrierLabel: '',
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     builder: (context) {
  //       return Center(
  //         child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 38),
  //           decoration: BoxDecoration(
  //             color: bgColor,
  //             borderRadius: BorderRadius.circular(30),
  //           ),
  //           child: LayoutBuilder(builder: (context, constraints) {
  //             double containerWidth = constraints.maxWidth;

  //             return Material(
  //               color: Colors.transparent,
  //               borderRadius: BorderRadius.circular(30),
  //               child: PopScope(
  //                 canPop: onWillPop,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     SizedBox(
  //                       height: 110,
  //                       width: 350,
  //                       child: Center(
  //                         child: Image.asset(
  //                           image,
  //                           height: 60,
  //                           width: 60,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.all(15),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             title ?? defTitle,
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.grey.shade800,
  //                             ),
  //                           ),
  //                           SizedBox(height: 15),
  //                           Text(
  //                             message ?? msg,
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w400,
  //                               color: Colors.grey.shade700,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
  //                       child: isYesNo
  //                           ? Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 PrimaryButton(
  //                                   text: 'No',
  //                                   textColor: themeContext.primaryColor,
  //                                   backgroundColor: lightMediumColor,
  //                                   width: (containerWidth / 2) - 20,
  //                                   onTap: () {
  //                                     Get.back();
  //                                     if (onTapCancel != null) onTapCancel!();
  //                                   },
  //                                 ),
  //                                 PrimaryButton(
  //                                   text: 'Yes',
  //                                   width: (containerWidth / 2) - 20,
  //                                   onTap: () {
  //                                     Get.back();
  //                                     if (onTap != null) onTap!();
  //                                   },
  //                                 ),
  //                               ],
  //                             )
  //                           : PrimaryButton(
  //                               text: 'Okay',
  //                               onTap: () {
  //                                 Get.back();
  //                                 if (onTap != null) onTap!();
  //                               },
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //         ),
  //       );
  //     },
  //   );
  // }
}
