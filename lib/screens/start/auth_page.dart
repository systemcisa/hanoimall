import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hanoimall/constants/common_size.dart';
import 'package:hanoimall/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder =
  const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  final TextEditingController _phoneNumberController =
  TextEditingController(text: "010");

  final TextEditingController _codeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  String? _verificationId;
  int? _forceResendingToken;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '전화번호 로그인',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(common_padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ExtendedImage.asset(
                          'assets/imgs/padlock.png',
                          width: size.width * 0.15,
                          height: size.width * 0.15,
                        ),
                        const SizedBox(
                          width: common_sm_padding,
                        ),
                        const Text('''기숙사앱은 휴대폰 번호로 가입해요.
번호는 안전하게 보관 되며
어디에도 공개되지 않아요.''')
                      ],
                    ),
                    const SizedBox(
                      height: common_padding,
                    ),
                    TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedInputFormatter("000 0000 0000")
                        ],
                        decoration: InputDecoration(
                            focusedBorder: inputBorder, border: inputBorder),
                        validator: (phoneNumber) {
                          if (phoneNumber != null && phoneNumber.length == 13) {
                            return null;
                          } else {
                            //error
                            return '전화번호를 확인 해주세요?';
                          }
                        }),
                    const SizedBox(
                      height: common_sm_padding,
                    ),
                    TextButton(
                        onPressed: () async {
                          if (_verificationStatus ==
                              VerificationStatus.codeSending) return;

                          if (_formKey.currentState != null) {
                            bool passed = _formKey.currentState!.validate();

                            if (passed) {
                              String phoneNum = _phoneNumberController.text;
                              phoneNum = phoneNum.replaceAll(' ', '');
                              phoneNum =
                                  phoneNum.replaceFirst('0', ''); //1055555555

                              FirebaseAuth auth = FirebaseAuth.instance;

                              setState(() {
                                _verificationStatus =
                                    VerificationStatus.codeSending;
                              });

                              await auth.verifyPhoneNumber(
                                phoneNumber: '+82$phoneNum',
                                forceResendingToken: _forceResendingToken,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) async {
                                  logger.d('verificationCompleted - $credential');
                                  await auth.signInWithCredential(credential);
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                                codeSent: (String verificationId,
                                    int? forceResendingToken) async {
                                  setState(() {
                                    _verificationStatus =
                                        VerificationStatus.codeSent;
                                  });
                                  _verificationId = verificationId;
                                  _forceResendingToken = forceResendingToken;
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {
                                  logger.e(error.message);

                                  setState(() {
                                    _verificationStatus =
                                        VerificationStatus.none;
                                  });
                                },
                              );
                            }
                          }
                        },
                        child: (_verificationStatus ==
                            VerificationStatus.codeSending)
                            ? const SizedBox(
                          height: 26,
                          width: 26,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text('인증문자 발송')),
                    const SizedBox(
                      height: common_padding,
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      opacity: (_verificationStatus == VerificationStatus.none)
                          ? 0
                          : 1,
                      child: AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationHeight(_verificationStatus),
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter("000000")],
                          decoration: InputDecoration(
                              focusedBorder: inputBorder, border: inputBorder),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        duration: duration,
                        curve: Curves.easeInOut,
                        height: getVerificationBtnHeight(_verificationStatus),
                        child: TextButton(
                            onPressed: () {
                              attemptVerify(context);
                            },
                            child: (_verificationStatus ==
                                VerificationStatus.verifying)
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : const Text('인증'))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_sm_padding;
    }
  }

  double getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codeSending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 48;
    }
  }

  void attemptVerify(BuildContext context) async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _codeController.text );

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      logger.e('verification failed!!');
      SnackBar snackbar = const SnackBar(
        content: Text('입력하신 코드가 틀려요!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });
  }
}

enum VerificationStatus {
  none,
  codeSending,
  codeSent,
  verifying,
  verificationDone
}
