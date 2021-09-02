import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immonot/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerAnnoncesHorizontal() {
  return Container(
    height: 250,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => {},
              child: Container(
                  height: 250,
                  width: 190,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
    ),
  );
}
