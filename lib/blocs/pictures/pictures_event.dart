part of 'pictures_bloc.dart';

abstract class PicturesEvent extends Equatable {
  const PicturesEvent();

  @override
  List<Object> get props => [];
}

class PictureLoaded extends PicturesEvent {
  final String request;

  const PictureLoaded(this.request);

  @override
  List<Object> get props => [request];

  @override
  String toString() => 'PictureLoaded { request: $request }';
}

class PictureSelectEvent extends PicturesEvent {
  final String picture;

  const PictureSelectEvent(this.picture);

  @override
  List<Object> get props => [picture];

  @override
  String toString() => 'PictureUpdatedEvent { picture: $picture }';
}

class PictureSelectConfirmEvent extends PicturesEvent {
  const PictureSelectConfirmEvent();
}
