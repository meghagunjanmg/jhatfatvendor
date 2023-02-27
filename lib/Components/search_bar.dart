import 'package:vendor/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final Function onTap;
  final Color color;
  final BoxShadow boxShadow;

  CustomSearchBar({
    this.hint,
    this.onTap,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(color: kCardBackgroundColor),
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: color ?? kCardBackgroundColor,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          icon: ImageIcon(
            AssetImage('images/icons/ic_search.png'),
            color: Colors.black,
            size: 16,
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.headline6,
          border: InputBorder.none,
        ),
        onTap: onTap,
      ),
    );
  }
}
