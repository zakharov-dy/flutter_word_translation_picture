import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_translation_picture/dataProvider/Repository.dart';

part 'pictures_event.dart';
part 'pictures_state.dart';

class PicturesBloc extends Bloc<PicturesEvent, PicturesState> {
  final Repository wordsRepository;

  PicturesBloc({required this.wordsRepository}) : super(PicturesLoadInProgress());

  @override
  Stream<PicturesState> mapEventToState(
    PicturesEvent event,
  ) async* {
    if (event is PictureLoaded) {
      yield* _mapPictureLoadedToState(event);
    } else if (event is PictureSelectEvent) {
      yield* _mapPictureSelectToState(event);
    } else if (event is PictureSelectConfirmEvent) {
      yield* _mapPictureSelectConfirmToState(event);
    }
  }

  Stream<PicturesState> _mapPictureLoadedToState(PictureLoaded event) async* {
    try {
      yield PicturesLoadInProgress();
      final pictures = await this.wordsRepository.getPictures(text: event.request);
      // TODO: Error?
      yield PictureSelectSuccess(pictures![0], pictures);
    } catch (_) {
      yield PicturesLoadFailure();
    }
  }

  Stream<PicturesState> _mapPictureSelectToState(PictureSelectEvent event) async* {
      yield PictureSelectSuccess(event.picture, (state as PictureSelectSuccess).pictures);
  }

  Stream<PicturesState> _mapPictureSelectConfirmToState(PictureSelectConfirmEvent event) async* {
      yield PictureSelectConfirm((state as PictureSelectSuccess).picture);
  }
}
