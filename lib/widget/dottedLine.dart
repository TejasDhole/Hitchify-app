// dotted_line_widget.dart

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class DottedLineWidget extends StatelessWidget {
  final Axis direction;
  final double lineLength;
  final double lineThickness;
  final double dashLength;
  final Color dashColor;
  final EdgeInsets padding;
  final double width;

  const DottedLineWidget({
    Key? key,
    this.direction = Axis.vertical,
    required this.lineLength,
    this.lineThickness = 2.0,
    this.dashLength = 3.0,
    this.dashColor = const Color.fromARGB(255, 52, 68, 207),
    this.padding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
    this.width = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: width,
            alignment: Alignment.center,
            child: DottedLine(
              direction: direction,
              lineLength: lineLength,
              lineThickness: lineThickness,
              dashLength: dashLength,
              dashColor: dashColor,
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
