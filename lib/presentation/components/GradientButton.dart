import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  const GradientElevatedButton({
    Key? key,
    required this.text,
    this.borderColor = Colors.transparent,
    this.borderRadiusIndex = 20,
    required this.topColor,
    required this.bottomColor,
    required this.textColor,
    this.buttonHeight = 30,
    this.buttonWidth = 178,
    this.textWeight = FontWeight.w700,
    this.textSize = 13,
    this.buttonElevation = 0,
    this.borderWidth = 1,
    this.buttonMargin = const EdgeInsets.only(top: 35),
    this.isLoading = false,
    required this.onPress,
    this.textFontStyle = FontStyle.normal,
    this.begin = Alignment.centerRight,
    this.end = Alignment.centerLeft,
  }) : super(key: key);

  final Color textColor;
  final FontWeight textWeight;
  final double textSize;
  final Color topColor;
  final Color bottomColor;
  final Color borderColor;
  final String text;
  final double borderRadiusIndex;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonElevation;
  final double borderWidth;
  final EdgeInsets buttonMargin;
  final bool isLoading;
  final FontStyle textFontStyle;
  final Alignment begin;
  final Alignment end;
  final void Function() onPress;

  @override
  State<StatefulWidget> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.buttonMargin,
      width: widget.buttonWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          )),
      child: SizedBox(
        height: widget.buttonHeight,
        child: ElevatedButton(
          onPressed: widget.onPress,
          style: ElevatedButton.styleFrom(
            elevation: widget.buttonElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
            ),
            padding: EdgeInsets.zero,
          ),
          child: InkWell(
            child: Container(
              height: widget.buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadiusIndex),
                gradient: LinearGradient(
                    begin: widget.begin,
                    end: widget.end,
                    colors: [
                      widget.topColor,
                      widget.bottomColor,
                    ]),
              ),
              child: Container(
                alignment: Alignment.center,
                height: widget.buttonHeight,
                child: widget.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: widget.textColor,
                        ),
                      )
                    : Text(
                        widget.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Be Vietnam Pro',
                          color: widget.textColor,
                          fontSize: widget.textSize,
                          fontWeight: widget.textWeight,
                          fontStyle: widget.textFontStyle
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
