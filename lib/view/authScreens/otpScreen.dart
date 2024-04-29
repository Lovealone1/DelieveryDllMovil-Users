import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/controller/provider/authProvider/MobileAuthProvider.dart';
import 'package:food_delievery/controller/services/authServices/mobileAuthServices.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  int resendOTPCounter = 60;

  decreaseOTPCounter() async {
    if (resendOTPCounter > 0) {
      setState(() {
        resendOTPCounter -= 1;
      });
      await Future.delayed(const Duration(seconds: 1), () {
        decreaseOTPCounter();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      decreaseOTPCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 10.w,
            bottom: 3.h,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.all(2.h),
                    backgroundColor: greyShade2,
                    elevation: 2),
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 2.h,
                  color: black,
                )),
          ),
          Positioned(
            right: 2.w,
            bottom: 3.h,
            child: ElevatedButton(
                onPressed: () {
                  MobileAuthServices.verifyOTP(
                      context: context, otp: otpController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    backgroundColor: greyShade2,
                    elevation: 2),
                child: Row(
                  children: [
                    Text(
                      'Siguiente',
                      style: AppTextStyles.body14,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 3.h,
                      color: black,
                    ),
                  ],
                )),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Digite el código de 6 dígitos enviado a ${context.read<MobileAuthProvider>().mobileNumber!}',
            style: AppTextStyles.body16,
          ),
          SizedBox(
            height: 3.h,
          ),
          PinCodeTextField(
            length: 6,
            appContext: context,
            obscureText: false,
            animationType: AnimationType.fade,
            textStyle: AppTextStyles.body14,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 50,
              activeFillColor: Colors.white,
              inactiveColor: greyShade3,
              inactiveFillColor: greyShade3,
              selectedFillColor: white,
              selectedColor: black,
              activeColor: black,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: transparent,
            enableActiveFill: true,
            errorAnimationController: errorController,
            controller: otpController,
            onCompleted: (v) {},
            onChanged: (value) {},
            beforeTextPaste: (text) {
              return true;
            },
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      50.sp,
                    ),
                    color: greyShade3),
                child: Text(
                  'No recibí un código($resendOTPCounter s)',
                  style: AppTextStyles.small10
                      .copyWith(color: resendOTPCounter > 0 ? black38 : black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
