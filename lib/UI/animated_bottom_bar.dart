import 'package:flutter/material.dart';
import 'package:vendor/Themes/colors.dart';
import 'package:vendor/Themes/style.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Function onBarTap;

  AnimatedBottomBar({
    this.barItems,
    this.onBarTap,
  });

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  Duration duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap(selectedBarIndex);
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          duration: duration,
          decoration: BoxDecoration(
              color: isSelected
                  ? kMainColor.withOpacity(0.075)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: <Widget>[
              ImageIcon(
                AssetImage(item.image),
                color: isSelected ? kMainColor : Colors.black,
              ),
              SizedBox(
                width: 10.0,
              ),
              AnimatedSize(
                duration: duration,
                curve: Curves.easeInOut,
                vsync: this,
                child: Text(
                  isSelected ? item.text : "",
                  style: bottomNavigationTextStyle,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }
}

class BarItem {
  String text;
  String image;

  BarItem({this.text, this.image});
}
