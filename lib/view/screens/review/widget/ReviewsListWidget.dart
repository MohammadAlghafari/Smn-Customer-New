import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';

import 'ReviewItemWidget.dart';



// ignore: must_be_immutable
class ReviewsListWidget extends StatelessWidget {
  List<Review> reviewsList;

  ReviewsListWidget({Key? key, required this.reviewsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reviewsList.isEmpty
        ? Container()
        : ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return ReviewItemWidget(review: reviewsList.elementAt(index));
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 20);
      },
      itemCount: reviewsList.length,
      primary: false,
      shrinkWrap: true,
    );
  }
}
