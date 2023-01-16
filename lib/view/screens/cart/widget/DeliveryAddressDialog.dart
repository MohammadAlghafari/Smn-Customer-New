import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../generated/l10n.dart';
import '../../../customWidget/CheckboxFormField.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  Function? onClose;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();
  late AppLocalizations _trans;

  DeliveryAddressDialog(
      {required this.context,
      required this.address,
      required this.onChanged,
      this.onClose}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          _trans = AppLocalizations.of(context)!;
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  _trans.add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: _trans.home_address,
                            labelText: _trans.description),
                        initialValue: address.description.isNotEmpty
                            ? address.description
                            : null,
                        validator: (input) => input!.trim().length == 0
                            ? _trans.not_valid_address_description
                            : null,
                        onSaved: (input) => address.description = input ?? '',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: _trans.hint_full_address,
                            labelText: _trans.full_address),
                        initialValue: address.address?.isNotEmpty ?? false
                            ? address.address
                            : null,
                        validator: (input) => input!.trim().length == 0
                            ? _trans.notValidAddress
                            : null,
                        onSaved: (input) => address.address = input,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault,
                        onSaved: (input) => address.isDefault = input as bool,
                        title: Text(_trans.makeItDefault),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  /* MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      _trans.cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ), */
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      _trans.close,
                      style:
                      TextStyle(color: Theme.of(context).hintColor,fontSize: 13),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      _trans.save,
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),

                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  InputDecoration getInputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2!.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState!.validate()) {
      _deliveryAddressFormKey.currentState!.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}
