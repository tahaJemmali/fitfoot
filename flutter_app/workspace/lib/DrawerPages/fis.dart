import 'dart:async';
import 'package:flutter/material.dart';

class FadingImagesSlider extends StatefulWidget {
  FadingImagesSlider({
    this.activeIconColor = Colors.black,
    this.passiveIconColor = Colors.grey,
    this.animationDuration = const Duration(milliseconds: 800),
    this.autoFade = true,
    this.icon = Icons.circle,
    this.iconSize = 8,
    @required this.images,
    @required this.texts,
    this.fadeInterval = const Duration(milliseconds: 5000),
    this.textAlignment = Alignment.bottomCenter,
  });

  final List<Image> images;
  final List<Text> texts;
  final IconData icon;
  final double iconSize;
  final Color activeIconColor;
  final Color passiveIconColor;
  final bool autoFade;
  final Duration animationDuration;
  final Duration fadeInterval;
  final Alignment textAlignment;

  @override
  _FadingImagesSliderState createState() => _FadingImagesSliderState();
}

class _FadingImagesSliderState extends State<FadingImagesSlider> {
  int _numberOfImage = 0;
  bool _onTapped = false;
  void checkListsLength() {
    if (widget.images.length != widget.texts.length) {
      throw 'images.length != texts.length';
    }
  }

  List<AnimatedOpacity> _animatedWidgetList = [];
  void _addImagesToList() {
    int i = 0;
    for (Image image in widget.images) {
      _animatedWidgetList.add(AnimatedOpacity(
        opacity: _numberOfImage == i ? 1.0 : 0.0,
        duration: widget.animationDuration,
        child: 
        Center(
              child: image,
            ),

        /*Stack(
          children: [
            Center(
              child: image,
            ),
            Align(
              alignment: widget.textAlignment,
              child: widget.texts[i],
            ),
          ],
        ),*/
      ));
      i++;
    }
  }

  @override
  void initState() {
    _addImagesToList();
    _addDots();
    _autoFade();
    super.initState();
  }

  List<Icon> _dots = [];

  void _addDots() {
    for (int j = 0; j < widget.images.length; j++) {
      _dots.add(Icon(
        widget.icon,
        size: widget.iconSize,
        color: _numberOfImage == j
            ? widget.activeIconColor
            : widget.passiveIconColor,
      ));
    }
  }

  void _numberOfImageIncrement() {
    if (_numberOfImage < widget.images.length - 1) {
      _numberOfImage++;
    } else {
      _numberOfImage = 0;
    }
    _dots = [];
    _addDots();
    _animatedWidgetList = [];
    _addImagesToList();
  }

  void _numberOfImageDecrement() {
    if (0 < _numberOfImage) {
      _numberOfImage--;
    } else {
      _numberOfImage = widget.images.length - 1;
    }
    _dots = [];
    _addDots();
    _animatedWidgetList = [];
    _addImagesToList();
  }

  void _autoFade() {
    if (widget.autoFade && _onTapped != true) {
      Timer.periodic(widget.fadeInterval, (timer) {
        if (_onTapped) {
          timer.cancel();
        } else if (!mounted){
          return;
        } else
          setState(() {
            _numberOfImageIncrement();
          });
      });
    }
  }

  @override
  void dispose() {
    _autoFade();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double start = 1;
    double end = 1;
    return /*Column(
      children: [*/
        /*Expanded(
          child:*/ GestureDetector(
            onTap: () {
              _numberOfImageIncrement();
              setState(() {
                _onTapped = true;
              });
            },
            onScaleStart: (details) {
              start = details.localFocalPoint.dx;
            },
            onScaleUpdate: (details) {
              end = details.localFocalPoint.dx;
            },
            onScaleEnd: (details) {
              setState(() {
                _onTapped = true;
              });
              if (start < end) {
                setState(() {
                  _numberOfImageIncrement();
                });
              } else {
                setState(() {
                  _numberOfImageDecrement();
                });
              }
            },
            child: Stack(
              children: _animatedWidgetList,
            ),
          );
        //),
        /*SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _dots,
        ),*/
      //],
    //);
  }
}