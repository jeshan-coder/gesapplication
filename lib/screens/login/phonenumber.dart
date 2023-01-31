import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:ges/navigators.dart';
import 'package:ges/screens/login/login.dart';
import 'package:ges/screens/login/signup.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:phone_auth_handler_demo/screens/home_screen.dart';
// import 'package:phone_auth_handler_demo/utils/helpers.dart';
// import 'package:phone_auth_handler_demo/widgets/custom_loader.dart';
// import 'package:phone_auth_handler_demo/widgets/pin_input_field.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';

  final String phoneNumber;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomViewInsets = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible = bottomViewInsets > 0;
  }

  // scroll to bottom of screen, when pin input field is in focus.
  Future<void> _scrollToBottomOnKeyboardOpen() async {
    while (!isKeyboardVisible) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    await Future.delayed(const Duration(milliseconds: 250));

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  TextEditingController pincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FirebasePhoneAuthHandler(
        phoneNumber: widget.phoneNumber,
        signOutOnSuccessfulVerification: false,
        linkWithExistingUser: false,
        autoRetrievalTimeOutDuration: const Duration(seconds: 60),
        otpExpirationDuration: const Duration(seconds: 60),
        onCodeSent: () {
          notification(context, "OTP sended");
        },
        onLoginSuccess: (userCredential, autoVerified) async {
          // log(
          //   VerifyPhoneNumberScreen.id,
          //   msg: autoVerified
          //       ? 'OTP was fetched automatically!'
          //       : 'OTP was verified manually!',
          // );

          notification(context, 'Phone number verified successfully!');

          // log(
          //   VerifyPhoneNumberScreen.id,
          //   msg: 'Login Success UID: ${userCredential.user?.uid}',
          // );
          // navigatorpushandremove(context, SignUp());
        },
        onLoginFailed: (authException, stackTrace) {
          // log(
          //   VerifyPhoneNumberScreen.id,
          //   msg: authException.message,
          //   error: authException,
          //   stackTrace: stackTrace,
          // );

          switch (authException.code) {
            case 'invalid-phone-number':
              // invalid phone number
              return notification(context, 'Invalid phone number!');

            case 'invalid-verification-code':
              // invalid otp entered
              return notification(context, 'The entered OTP is invalid!');
            // handle other error codes
            default:
              notification(context, 'Something went wrong!');
              navigatorpushandremove(context, Login());
            // handle error further if needed
          }
        },
        onError: (error, stackTrace) {
          // log(
          //   VerifyPhoneNumberScreen.id,
          //   error: error,
          //   stackTrace: stackTrace,
          // );

          notification(context, 'An error occurred!');
        },
        builder: (context, controller) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 0,
              leading: const SizedBox.shrink(),
              title: const Text('Verify Phone Number'),
              actions: [
                if (controller.codeSent)
                  TextButton(
                    onPressed: controller.isOtpExpired
                        ? () async {
                            // log(VerifyPhoneNumberScreen.id,
                            //     message: 'Resend OTP');
                            await controller.sendOTP();
                          }
                        : null,
                    child: Text(
                      controller.isOtpExpired
                          ? 'Resend'
                          : '${controller.otpExpirationTimeLeft.inSeconds}s',
                      style: const TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                const SizedBox(width: 5),
              ],
            ),
            body: controller.isSendingCode
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomLoader(),
                      const SizedBox(height: 50),
                      const Center(
                        child: Text(
                          'Sending OTP',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    children: [
                      Text(
                        "We've sent an SMS with a verification code to ${widget.phoneNumber}",
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (controller.isListeningForOtpAutoRetrieve)
                        Column(
                          children: [
                            CustomLoader(),
                            SizedBox(height: 50),
                            const Text(
                              'Listening for OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(),
                            Text('OR', textAlign: TextAlign.center),
                            Divider(),
                          ],
                        ),
                      const SizedBox(height: 15),
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      PinCodeTextField(
                        length: 6,
                        // onFocusChange: (hasFocus) async {
                        //   if (hasFocus) await _scrollToBottomOnKeyboardOpen();
                        // },
                        onChanged: (value) {
                          setState(() {
                            pincontroller.text = value;
                          });
                        },
                        onCompleted: (enteredOtp) async {
                          final verified =
                              await controller.verifyOtp(pincontroller.text);
                          if (verified) {
                            navigatorpushandremove(
                                context, SignUp(widget.phoneNumber));
                            // number verify success
                            // will call onLoginSuccess handler
                          } else {
                            notification(context, "Error occured");
                            navigatorpushandremove(context, Login());
                            // phone verification failed
                            // will call onLoginFailed or onError callbacks with the error
                          }
                        },
                        appContext: context,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget CustomLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
