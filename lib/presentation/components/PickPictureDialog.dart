import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_translation_picture/blocs/pictures/pictures_bloc.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';
import 'package:word_translation_picture/presentation/components/ImageSlider.dart';
import 'package:word_translation_picture/presentation/components/share/CircleButton.dart';

const clickableCircleMargin = 30.0;

class PickPictureDialog extends StatelessWidget {
  PickPictureDialog({Key? key, required this.eng}) : super(key: key);

  final String eng;

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery
        .of(context)
        .size
        .width;
    // For fix issue "widgets in the overflow of stack do not respond to gestures"
    // I just wrap my Stack in one more container;
    // Real Stack size just more than visible part;
    //https://github.com/flutter/flutter/issues/19445
    return BlocProvider<PicturesBloc>(
      // TODO: Repository() вынести
      create: (BuildContext context) =>
      PicturesBloc(wordsRepository: Repository())
        ..add(PictureLoaded(this.eng)),
      child: AlertDialog(
        elevation: 0,
        contentPadding: EdgeInsets.all(0),
        insetPadding: EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        content: BlocConsumer<PicturesBloc, PicturesState>(
          listener: (context, state) {
            if (state is PictureSelectConfirm) {
              Navigator.of(context, rootNavigator: true).pop(state.picture);
              // Navigator.pop(context, state.picture);
            }

            if (state is PicturesLoadFailure) {
              Navigator.of(context, rootNavigator: true).pop(null);
              // Navigator.pop(context, state.picture);
            }
          },
          builder: (context, state) {
            if (state is PictureSelectSuccess) {
              // Full size container for render clickable circle buttons;
              return Container(
                width: fullWidth,
                color: Colors.transparent,
                child: Stack(
                    fit: StackFit.loose, clipBehavior: Clip.none, children: [
                  // Margin color container;
                  Container(
                      margin: EdgeInsets.all(clickableCircleMargin),
                      child: PhysicalModel(
                        color: Colors.white,
                        elevation: 15,
                        shadowColor: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(5),
                        // Column for fix height by mainAxisSize: MainAxisSize.min;
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Padding container for use symmetric padding and PhysicalModel together;
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: ImageSlider(
                                  onPageChanged: (String image) {
                                    context.read<PicturesBloc>().add(
                                        PictureSelectEvent(image));
                                  },
                                  imgList: state.pictures),
                            ),
                          ],
                        ),
                      )),
                  _DoneButton(),
                  _CancelButton()
                ]),
              );
            } else {
              return Column(
                children: [
                  CircularProgressIndicator(),
                ],
                mainAxisSize: MainAxisSize.min,
              );
            }
          },
        ),
      ),
    );
  }
}

const buttonSize = 50.0;
const buttonSizeHalf = buttonSize / 2;
const positionedMargin = buttonSizeHalf - clickableCircleMargin / 2;

class _DoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Positioned(
        right: positionedMargin,
        bottom: positionedMargin,
        child: CircleButton(
          onPressed: () {
            context.read<PicturesBloc>().add(PictureSelectConfirmEvent());
          },
          fillColor: Colors.deepPurple,
          icon: Icon(
            Icons.done_outlined,
            color: Colors.white,
          ),
          size: buttonSize,
        ),
      );
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Positioned(
        right: positionedMargin,
        top: positionedMargin,
        child: CircleButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(null);
          },
          fillColor: Colors.deepOrange,
          icon: const Icon(
            Icons.close_outlined,
            color: Colors.white,
          ),
          size: 50,
        ),
      );
}
