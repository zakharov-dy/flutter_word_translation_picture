import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'checkbox_list_state.dart';

class CheckboxListCubit extends Cubit<CheckboxListState> {
  CheckboxListCubit() : super(CheckboxListDisabled());

  void toggleState() {
    if(state is CheckboxListDisabled){
      emit(CheckboxListEnabled());
    } else {
      emit(CheckboxListDisabled());
    }
  }

  void disable() {
    emit(CheckboxListDisabled());
  }

  void toggleCheckbox(int id){
    if(state is CheckboxListEnabled){
      final oldState = (state as CheckboxListEnabled);
      final newSet = {...oldState.values};
      if(oldState.values.contains(id)){
        newSet.remove(id);
      } else {
        newSet.add(id);
      }

      emit(CheckboxListEnabled(values: newSet));
    }
  }
}
