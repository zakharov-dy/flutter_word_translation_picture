part of 'checkbox_list_cubit.dart';

const defaultSet = <int>{};

@immutable
abstract class CheckboxListState {}

class CheckboxListDisabled extends CheckboxListState {}

class CheckboxListEnabled extends CheckboxListState {
  CheckboxListEnabled({this.values = defaultSet}) : super();
  final Set<int> values;

  get isEmpty => values.isEmpty;
}
