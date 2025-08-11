import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double fontSize;
  final double hsize;
  final double wsize;

  const LogoWidget({
    super.key,
    this.fontSize = 127,
    this.hsize = 140,
    this.wsize = 340,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: wsize,
      height: hsize,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          hsize / 4.5,
        ), // proportional rounding
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'ECOM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontFamily: Theme.of(context).textTheme.displaySmall?.fontFamily,
          ),
        ),
      ),
    );

    return logo;
  }
}
