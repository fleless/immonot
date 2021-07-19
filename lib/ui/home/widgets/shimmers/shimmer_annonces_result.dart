import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerSearchAnnonces() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    enabled: true,
    child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 10,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
                height: 333,
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  color: AppColors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                    ],
                  )),
            )),
          );
        }),
  );
}
