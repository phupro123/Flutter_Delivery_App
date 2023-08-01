import 'package:flutter/material.dart';
import 'package:project_final/const/colors.dart';
import 'package:project_final/utils/helper.dart';

class SearchBar extends StatelessWidget {
  final String title;

  SearchBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search
          ),
          hintText: title,
          hintStyle: TextStyle(
            color: AppColor.placeholder,
            fontSize: 18,
          ),
          contentPadding: const EdgeInsets.only(
            top: 17,
          ),
        ),
      ),
    );
  }
}
