import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/myColors.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:smn_delivery_app/view/customWidget/BlockButtonWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late AppLocalizations _trans;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  bool hidePassword = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CountryCode? countryCode = CountryCode(
      name: 'دولة الإمارات العربية المتحدة', code: 'AE', dialCode: '+971');
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          SizedBox(
            width: config.App().appWidth(100),
            height: 10000,
          ),
          Positioned(
            top: 0,
            child: Container(
              width: config.App().appWidth(100),
              height: config.App().appHeight(29.5),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: config.App().appHeight(29.5) - 120,
                        left: 35,
                        right: 35,
                        bottom: 20,
                      ),
                      child: Text(
                        _trans.lets_start_with_register,
                        style: Theme.of(context).textTheme.headline2!.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(const Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 50,
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                          )
                        ]),
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 27),
                    width: config.App().appWidth(88),
                    //   height: config.App().appHeight(55),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: name,
                            validator: (input) => input!.length < 3
                                ? _trans.should_be_more_than_3_letters
                                : null,
                            decoration: InputDecoration(
                              labelText: _trans.full_name,
                              labelStyle: TextStyle(
                                  color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.all(12),
                              hintText: _trans.john_doe,
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            textDirection: TextDirection.ltr,

                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: email,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(phoneNode);
                            },
                            validator: (input) => !input!.contains('@')
                                ? _trans.should_be_a_valid_email
                                : null,
                            decoration: InputDecoration(
                              labelText: _trans.email,
                              labelStyle: TextStyle(
                                  color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.all(12),
                              hintText: 'johndoe@gmail.com',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.alternate_email,
                                  color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              controller: phone,
                              focusNode: phoneNode,
                              maxLength: 9,
                              validator: (input) {
                                if (input!.length < 9) {
                                  return _trans.not_a_valid_phone;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: _trans.phoneNumber,
                                labelStyle: TextStyle(
                                    color: Colors.grey[600]),
                                contentPadding: const EdgeInsets.all(12),
                                hintText: '53 624 6995',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: CountryCodePicker(
                                  onChanged: (v) {
                                    countryCode = v;
                                  },
                                  boxDecoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor
                                  ),
                                  padding: EdgeInsets.zero,
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'AE',
                                  favorite: const ['+966', '+971'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            obscureText: hidePassword,
                            controller: password,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(confirmPasswordNode);
                            },
                            validator: (v) {
                              if (v!.length < 8) {
                                return _trans.should_be_more_than_7_letters;
                              }
                              if (confirmPassword.text.trim() !=
                                  password.text.trim()) {
                                return _trans.password_dose_not_match;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: _trans.password,
                              labelStyle: TextStyle(
                                  color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Colors.grey[600]),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            textDirection: TextDirection.ltr,
                            textInputAction: TextInputAction.done,
                            obscureText: hidePassword,
                            focusNode: confirmPasswordNode,
                            controller: confirmPassword,
                            validator: (v) {
                              if (v!.length < 8) {
                                return _trans.should_be_more_than_7_letters;
                              }
                              if (confirmPassword.text.trim() !=
                                  password.text.trim()) {
                                return _trans.password_dose_not_match;
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              if (_formKey.currentState!.validate()) {
                                if (confirmPassword.text.trim() !=
                                    password.text.trim()) {
                                  showToast(
                                      context: context,
                                      message: _trans.password_dose_not_match);
                                } else {
                                  FocusScope.of(context).unfocus();
                                  Provider.of<AuthViewModel>(context,
                                          listen: false)
                                      .checkRegister(
                                          scaffoldKey: scaffoldKey,
                                          context: context,
                                          body: {
                                        'name': name.text,
                                        'email': email.text,
                                        'password': password.text,
                                        'phone':
                                            countryCode!.dialCode! + phone.text,
                                        'country': countryCode!.code!
                                      });
                                }
                              }
                            },
                            decoration: InputDecoration(
                              labelText: _trans.confirm_password,
                              labelStyle: TextStyle(
                                  color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.all(12),
                              hintText: '••••••••••••',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Colors.grey[600]),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          const SizedBox(height: 50),
                          BlockButtonWidget(
                            text: Text(
                              _trans.register,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                Provider.of<AuthViewModel>(context,
                                        listen: false)
                                    .checkRegister(
                                        scaffoldKey: scaffoldKey,
                                        context: context,
                                        body: {
                                      'name': name.text,
                                      'email': email.text,
                                      'password': password.text,
                                      'phone':
                                          countryCode!.dialCode! + phone.text,
                                      'country': countryCode!.code!
                                    });
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('LoginScreen');
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Text(_trans.i_have_account_back_to_login),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: myColors.orange,
                            width: 2.0,
                          ),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(myColors.orange)),
                  onPressed: () {
                    if (Provider.of<SettingViewModel>(context, listen: false)
                            .setting
                            .mobileLanguage
                            .languageCode ==
                        'en') {
                      Provider.of<SettingViewModel>(context, listen: false)
                          .changeLanguage('ar');
                    } else {
                      Provider.of<SettingViewModel>(context, listen: false)
                          .changeLanguage('en');
                    }
                  },
                  child: Text(
                      Provider.of<SettingViewModel>(context, listen: false)
                                  .setting
                                  .mobileLanguage
                                  .languageCode ==
                              'en'
                          ? 'العربية'
                          : 'English'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    confirmPasswordNode.dispose();
    phoneNode.dispose();
    super.dispose();
  }
}
