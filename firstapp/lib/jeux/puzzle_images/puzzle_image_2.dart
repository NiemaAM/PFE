import 'dart:math';
import 'dart:ui';

import 'package:firstapp/widgets/app_text.dart';
import 'package:firstapp/widgets/menue_retour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image/image.dart' as image;

import '../../widgets/pop_up_quiz.dart';

// make statefull widget for testing
// ignore: camel_case_types
class SlidePuzzle_2 extends StatefulWidget {
  const SlidePuzzle_2({Key key}) : super(key: key);

  @override
  _SlidePuzzle_2State createState() => _SlidePuzzle_2State();
}

// ignore: camel_case_types
class _SlidePuzzle_2State extends State<SlidePuzzle_2> {
  // default put 2
  int valueSlider = 3;
  GlobalKey<_SlidePuzzle_2WidgetState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset("assets/img/haut.png"),
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const retour(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: height / 6,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(width / 80),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.biggest.width,
                            // comment of this so our box can extends height
                            // height: constraints.biggest.width,

                            // if setup decoration,color must put inside
                            // make puzzle widget
                            child: SlidePuzzle_2Widget(
                              key: globalKey,
                              size: constraints.biggest,
                              // set size puzzle
                              imageBckGround: const Image(
                                // u can use your own image
                                image: AssetImage("./assets/img/avatar_2.png"),
                              ),
                              sizePuzzle: valueSlider,
                            ),
                          );
                        },
                      ),
                      // child: ,
                    ),
                    Slider(
                      min: 3,
                      max: 8,
                      divisions: 3,
                      label: valueSlider.toString(),
                      value: valueSlider.toDouble(),
                      onChanged: (value) {
                        setState(
                          () {
                            valueSlider = value.toInt();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

String img() {
  dynamic listImagesnotFound = [
    "./assets/img/avatar_1.png",
    "./assets/img/avatar_2.png",
    "./assets/img/avatar_3.png",
    "./assets/img/avatar_4.png",
    "./assets/img/avatar_5.png",
    "./assets/img/avatar_6.png"
  ];
  Random rnd;
  int min = 0;
  int max = listImagesnotFound.length - 1;
  rnd = Random();
  int r = min + rnd.nextInt(max - min);
  String imageName = listImagesnotFound[r].toString();
  return imageName;
}

// statefull widget
// ignore: camel_case_types, must_be_immutable
class SlidePuzzle_2Widget extends StatefulWidget {
  Size size;
  // set inner padding
  double innerPadding;
  // set image use for background
  Image imageBckGround;
  int sizePuzzle;
  SlidePuzzle_2Widget({
    Key key,
    this.size,
    this.innerPadding = 3,
    this.imageBckGround,
    this.sizePuzzle,
  }) : super(key: key);

  @override
  _SlidePuzzle_2WidgetState createState() => _SlidePuzzle_2WidgetState();
}

// ignore: camel_case_types
class _SlidePuzzle_2WidgetState extends State<SlidePuzzle_2Widget> {
  final GlobalKey _globalKey = GlobalKey();
  Size size;

  // list array slide objects
  List<SlideObject> slideObjects;
  // image load with renderer
  image.Image fullImage;
  // success flag
  bool success = false;
  // flag already start slide
  bool startSlide = false;
  bool reversed = false;
  // save current swap process for reverse checking
  List<int> process;
  // flag finish swap
  bool finishSwap = false;

  @override
  Widget build(BuildContext context) {
    size = Size(widget.size.width - widget.innerPadding * 2,
        widget.size.width - widget.innerPadding);
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      // let make ui
      children: [
        // make 2 column, 1 for puzzle box, 2nd for button testing
        Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          width: widget.size.width,
          height: widget.size.width,
          padding: EdgeInsets.all(widget.innerPadding),
          child: Stack(
            children: [
              // we use stack stack our background & puzzle box
              // 1st show image use

              // ignore: sdk_version_ui_as_code
              if (widget.imageBckGround != null && slideObjects == null) ...[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.blue,
                    height: double.maxFinite,
                    child: widget.imageBckGround,
                  ),
                )
              ],
              // 2nd show puzzle with empty
              // ignore: sdk_version_ui_as_code
              if (slideObjects != null)
                ...slideObjects.where((slideObject) => slideObject.empty).map(
                  (slideObject) {
                    return Positioned(
                      left: slideObject.posCurrent.dx,
                      top: slideObject.posCurrent.dy,
                      child: SizedBox(
                        width: slideObject.size.width,
                        height: slideObject.size.height,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(2),
                          color: Colors.white24,
                          child: Stack(
                            children: [
                              if (slideObject.image != null) ...[
                                Opacity(
                                  opacity: success ? 1 : 0.3,
                                  child: slideObject.image,
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              // this for box with not empty flag
              // ignore: sdk_version_ui_as_code
              if (slideObjects != null)
                ...slideObjects.where((slideObject) => !slideObject.empty).map(
                  (slideObject) {
                    // change to animated position
                    // disabled checking success on swap process
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                      left: slideObject.posCurrent.dx,
                      top: slideObject.posCurrent.dy,
                      child: GestureDetector(
                        onTap: () => changePos(slideObject.indexCurrent),
                        child: SizedBox(
                          width: slideObject.size.width,
                          height: slideObject.size.height,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                if (slideObject.image != null) ...[
                                  slideObject.image
                                ],

                                // nice one.. lets make it random
                              ],
                            ),
                            // nice one
                          ),
                        ),
                      ),
                    );
                  },
                ).toList()

              // now not show at all because we dont generate slideObjects yet.. lets generate
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // u can use any button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => generatePuzzle(),
                child: AppText(
                  text: "Diviser",
                  size: width / 14,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                // for checking purpose
                onPressed: startSlide ? null : () => reversePuzzle(),
                child: AppText(
                    text: "Resoudre", size: width / 14, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => clearPuzzle(),
                child: AppText(
                    text: "Image", size: width / 14, color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }

  // get render image
  // same as jigsaw puzzle method before

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    return image.decodeImage(pngBytes);
  }

  // method to generate our puzzle
  generatePuzzle() async {
    reversed = false;
    // dclare our array puzzle
    finishSwap = false;
    setState(() {});
    // 1st load render image to crop, we need load just once
    if (widget.imageBckGround != null && fullImage == null) {
      fullImage = await _getImageFromWidget();
    }

    // ignore: avoid_print
    print(fullImage.width);
    // ok nice..full image loaded

    // calculate box size for each puzzle
    Size sizeBox =
        Size(size.width / widget.sizePuzzle, size.width / widget.sizePuzzle);

    // let proceed with generate box puzzle
    // power of 2 because we need generate row & column same number
    slideObjects =
        List.generate(widget.sizePuzzle * widget.sizePuzzle, (index) {
      // we need setup offset 1st
      Offset offsetTemp = Offset(
        index % widget.sizePuzzle * sizeBox.width,
        index ~/ widget.sizePuzzle * sizeBox.height,
      );

      // set image crop for nice effect, check also if image is null
      image.Image tempCrop;
      if (widget.imageBckGround != null && fullImage != null) {
        tempCrop = image.copyCrop(
          fullImage,
          offsetTemp.dx.round(),
          offsetTemp.dy.round(),
          sizeBox.width.round(),
          sizeBox.height.round(),
        );
      }

      return SlideObject(
        posCurrent: offsetTemp,
        posDefault: offsetTemp,
        indexCurrent: index,
        indexDefault: index + 1,
        size: sizeBox,
        image: tempCrop == null
            ? null
            : Image.memory(
                image.encodePng(tempCrop),
                fit: BoxFit.contain,
              ),
      );
    }); //let set empty on last child

    slideObjects.last.empty = true;

    // make random.. im using smple method..just rndom with move it.. haha

    // setup moveMethod 1st
    // proceed with swap block place
    // swap true - we swap horizontal line.. false - vertical
    bool swap = true;
    process = [];

    // 20 * size puzzle shuffle
    for (var i = 0; i < widget.sizePuzzle * 20; i++) {
      for (var j = 0; j < widget.sizePuzzle / 2; j++) {
        SlideObject slideObjectEmpty = getEmptyObject();

        // get index of empty slide object
        int emptyIndex = slideObjectEmpty.indexCurrent;
        process.add(emptyIndex);
        int randKey;

        if (swap) {
          // horizontal swap
          int row = emptyIndex ~/ widget.sizePuzzle;
          randKey =
              row * widget.sizePuzzle + Random().nextInt(widget.sizePuzzle);
        } else {
          int col = emptyIndex % widget.sizePuzzle;
          randKey =
              widget.sizePuzzle * Random().nextInt(widget.sizePuzzle) + col;
        }

        // call change pos method we create before to swap place

        changePos(randKey);
        // ops forgot to swap
        // hmm bug.. :).. let move 1st with click..check whther bug on swap or change pos
        swap = !swap;
      }
    }

    startSlide = false;
    finishSwap = true;
    setState(() {});
  }
  // eyay.. end

  // get empty slide object from list
  SlideObject getEmptyObject() {
    return slideObjects.firstWhere((element) => element.empty);
  }

  changePos(int indexCurrent) {
    // problem here i think..
    SlideObject slideObjectEmpty = getEmptyObject();

    // get index of empty slide object
    int emptyIndex = slideObjectEmpty.indexCurrent;

    // min & max index based on vertical or horizontal

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    // temp list moves involves
    List<SlideObject> rangeMoves = [];

    // check if index current from vertical / horizontal line
    if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
      // same vertical line
      rangeMoves = slideObjects
          .where((element) =>
              element.indexCurrent % widget.sizePuzzle ==
              indexCurrent % widget.sizePuzzle)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle ==
        emptyIndex ~/ widget.sizePuzzle) {
      rangeMoves = slideObjects;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
            puzzle.indexCurrent >= minIndex &&
            puzzle.indexCurrent <= maxIndex &&
            puzzle.indexCurrent != emptyIndex)
        .toList();

    // check empty index under or above current touch
    if (emptyIndex < indexCurrent) {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 1 : 0);
    } else {
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 0 : 1);
    }

    // check if rangeMOves is exist,, then proceed switch position
    if (rangeMoves.isNotEmpty) {
      int tempIndex = rangeMoves[0].indexCurrent;

      Offset tempPos = rangeMoves[0].posCurrent;

      // yeayy.. sorry my mistake.. :)
      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      // haha ..i forget to setup pos for empty puzzle box.. :p
      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    // this to check if all puzzle box already in default place.. can set callback for success later
    if (slideObjects
                .where((slideObject) =>
                    slideObject.indexCurrent == slideObject.indexDefault - 1)
                .length ==
            slideObjects.length &&
        finishSwap) {
      // ignore: avoid_print
      print("Success");
      success = true;
    } else {
      success = false;
    }

    if (success == true && reversed == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialogBox(
              text: "Retour",
              descriptions: "Ton score est maintenant :",
              title: "Bien jouer !",
            );
          });
    }

    startSlide = true;
    setState(() {});
  }

  clearPuzzle() {
    setState(() {
      // checking already slide for reverse purpose
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    reversed = true;
    setState(() {});

    await Stream.fromIterable(process.reversed)
        .asyncMap((event) async =>
            await Future.delayed(const Duration(milliseconds: 50))
                .then((value) => changePos(event)))
        .toList();

    // yeayy
    process = [];
    setState(() {});
  }
}

// lets start class use
class SlideObject {
  // setup offset for default / current position
  Offset posDefault;
  Offset posCurrent;
  // setup index for default / current position
  int indexDefault;
  int indexCurrent;
  // status box is empty
  bool empty;
  // size each box
  Size size;
  // Image field for crop later
  Image image;

  SlideObject({
    this.empty = false,
    this.image,
    this.indexCurrent,
    this.indexDefault,
    this.posCurrent,
    this.posDefault,
    this.size,
  });
}
