part of 'pictures_bloc.dart';

abstract class PicturesState extends Equatable {
  const PicturesState();

  @override
  List<Object> get props => [];
}

class PicturesLoadInProgress extends PicturesState {}

class PicturesLoadFailure extends PicturesState {}

class PictureSelectSuccess extends PicturesState {
  final List<String> pictures;
  final String picture;

  const PictureSelectSuccess(this.picture, this.pictures);

  @override
  List<Object> get props => [picture, this.pictures];

  @override
  String toString() => 'PicturesLoadSuccess { picture: $picture }';
}


class PictureSelectConfirm extends PicturesState {
  final String picture;

  const PictureSelectConfirm(this.picture);

  @override
  List<Object> get props => [picture];

  @override
  String toString() => 'PicturesLoadSuccess { picture: $picture }';
}
