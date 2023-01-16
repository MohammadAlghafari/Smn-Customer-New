import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/utili/app_config.dart'as config;
import 'package:smn_delivery_app/view/customWidget/BlockButtonWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();
  final TextEditingController emailCont = TextEditingController();
  late AppLocalizations _trans;
  @override
  Widget build(BuildContext context) {
    _trans=AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App().appWidth(100),
              height: config.App().appHeight(37),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: config.App().appHeight(37) - 120,
            child: Container(
              width: config.App().appWidth(84),
              height: config.App().appHeight(37),
              child: Text(
                _trans.email_to_reset_password,
                style: Theme.of(context).textTheme.headline2!.merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App().appHeight(37) - 50,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                BoxShadow(
                  blurRadius: 50,
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                )
              ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
              width: config.App().appWidth(88),
//              height: config.App().appHeight(55),
              child: Form(
                key:loginFromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailCont,
                      validator: (input) => !input!.contains('@') ? _trans.should_be_a_valid_email : null,
                      decoration: InputDecoration(
                        labelText: _trans.email,
                        labelStyle: TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'johndoe@gmail.com',
                        hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        _trans.send_password_reset_link,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        if(loginFromKey.currentState!.validate())
                        Provider.of<AuthViewModel>(context,listen: false).resetPassword(emailCont.text,context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('LoginScreen');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text(_trans.i_remember_my_password_return_to_login),
                ),
                /* FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/SignUp');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text(S.of(context).i_dont_have_an_account),
                ), */
              ],
            ),
          )
        ],
      ),
    );
  }
}
