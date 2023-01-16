import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/faq_help/widget/faq_item_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/faq_veiw_model.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Consumer<FaqViewModel>(builder: (context, faqModel, child) {
      return faqModel.loadingData
          ? Scaffold(
        body: CircularLoadingWidget(height: 900),
      )
          : DefaultTabController(
        length: faqModel.faqs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // key: _con.scaffoldKey,
         // drawer: const DrawerWidget(),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Theme.of(context).accentColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            bottom: TabBar(
              tabs: List.generate(faqModel.faqs.length, (index) {
                return Tab(text: faqModel.faqs.elementAt(index).name );
              }),
              labelColor: Theme.of(context).primaryColor,
            ),
            title: Text(
              _trans.faq,
              style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
                  letterSpacing: 1.3,
                  color: Theme.of(context).primaryColor)),
            ),
            actions: <Widget>[
              ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).accentColor,
                  labelColor: Theme.of(context).accentColor),
            ],
          ),
          body: getFaqWidget(faqModel),
        ),
      );
    },);
  }

  getFaqWidget(FaqViewModel faqModel) {
    if(faqModel.faqs.isEmpty){
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/Error.png',width: 200,),
          SizedBox(height: 30,),
          Text(
            _trans.oops_Check_your_internet_connection,
            style: const TextStyle(fontSize: 18),
          ),
          SizedBox(height: 40,),
          IconButton(onPressed: (){
            Provider.of<FaqViewModel>(context, listen: false)
                .listenForFaqs();
          }, icon: Icon(Icons.refresh, color: Theme.of(context).hintColor,size: 35,))
        ],
      ),);
    }
    return TabBarView(
      children: List.generate(faqModel.faqs.length, (index) {
        return RefreshIndicator(
          onRefresh: faqModel.refreshFaqs,

          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SizedBox(height: 15),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.help,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _trans.help_supports,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: faqModel.faqs.elementAt(index).faqs.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 15);
                  },
                  itemBuilder: (context, indexFaq) {
                    return FaqItemWidget(
                        faq: faqModel.faqs
                            .elementAt(index)
                            .faqs
                            .elementAt(indexFaq));
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

}
