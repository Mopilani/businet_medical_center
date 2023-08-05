
import 'package:flutter/material.dart';

Widget tapBarWidget(text1, text2) {
  return SizedBox(
    height: 40,
    child: TabBar(
      tabs: [
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              text1,
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              text2,
            ),
          ),
        ),
      ],
    ),
  );
}
