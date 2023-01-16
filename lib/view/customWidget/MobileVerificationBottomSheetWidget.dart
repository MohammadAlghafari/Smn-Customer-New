import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart' as userModel;
import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:smn_delivery_app/const/widgets.dart';

import '../../smn_customer.dart';
import '../../view_models/auth_view_model.dart';
import 'BlockButtonWidget.dart';

class MobileVerificationBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String phone;
  final userModel.User user;

  const MobileVerificationBottomSheetWidget(
      {Key? key,
        required this.scaffoldKey,
        required this.phone,
        required this.user})
      : super(key: key);

  @override
  _MobileVerificationBottomSheetWidgetState createState() =>
      _MobileVerificationBottomSheetWidgetState();
}

class _MobileVerificationBottomSheetWidgetState
    extends State<MobileVerificationBottomSheetWidget> {
  String? errorMessage;
  TextEditingController textController = TextEditingController();
  late AppLocalizations _trans;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    //verifyPhone();
    super.initState();
  }

  verifyCode(String code) async {
    final verified = await Provider.of<AuthViewModel>(context, listen: false)
        .verifyOTP(widget.phone, code);
    if (verified) {
      widget.user.verifiedPhone = true;
      Navigator.of(context).pop(true);
    }
    else {
      Navigator.of(context).pop(false);
    }
  }

  /* verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    void smsCodeSent(String verId, [int? forceCodeResent]) {
      print('verId: ' + verId);
      setState(() {
        widget.user.verificationId = verId;
      });
    }

    final PhoneVerificationCompleted _verifiedSuccess =
        (AuthCredential auth) {};
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {

      print('dfdf');
      showToast(
          context: context,
          message: e.message.toString());
      Navigator.of(widget.scaffoldKey.currentContext!).pop(false);
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: widget.phone,
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    )
        .onError((error, stackTrace) {
      showToast(
          context: context,
          message: AppLocalizations.of(
              NavigationService.navigatorKey.currentContext!)!
              .verify_your_internet_connection);
      Navigator.of(widget.scaffoldKey.currentContext!).pop(false);
    });
  }

  verifyCode(String code) async {
    print(widget.user.verificationId);
    FocusScope.of(context).unfocus();
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.user.verificationId ?? '', smsCode: code);

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      widget.user.verifiedPhone = true;
      Navigator.of(context).pop(true);
    }).catchError((e) {
      setState(() {
        errorMessage = e.toString().split('\]').last;
      });
      print(e.toString());
    });
  } */

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height:  350,
          decoration: BoxDecoration   (
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.4),
                  blurRadius: 30,
                  offset: Offset(0, -30)),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView(
                  padding:
                  EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
                  children: <Widget>[
                    Text(
                      _trans.verifyPhoneNumber,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    errorMessage == null
                        ? Text(
                      _trans.weAreSendingOtpToValidateYourMobileNumberHang,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    )
                        : Text(
                      errorMessage ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .merge(TextStyle(color: Colors.redAccent)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    PinPut(
                      fieldsCount: 6,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .merge(TextStyle(color: Colors.redAccent)),
                      submittedFieldDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent)),
                      selectedFieldDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.redAccent)),
                      followingFieldDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber[700]!)),
                      onClipboardFound: (code) {
                        //verifyCode(code);
                      },
                      onChanged: (value) {
                       if (value.length == 6) verifyCode(value);
                      },
                      controller: textController,
                    ),
                    SizedBox(height: 15),
                    Text(
                      _trans.smsHasBeenSentTo + ' ' + widget.phone,
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 80),
                    BlockButtonWidget(
                      onPressed: textController.text == '' ||
                          textController.text == null ||
                          textController.text.length < 6
                          ? () {}
                          : () => verifyCode(textController.text),
                      color: Theme.of(context).accentColor,
                      text: Text(_trans.verify.toUpperCase(),
                          style: Theme.of(context).textTheme.headline6!.merge(
                              TextStyle(color: Theme.of(context).primaryColor))),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: 13, horizontal: config.App().appWidth(42)),
                decoration: BoxDecoration(
                  color: Theme.of(context).focusColor.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                ),
                child: Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
