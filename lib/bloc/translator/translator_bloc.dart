import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionstore/data/entity/translator_language.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/translator_repository.dart';

part 'translator_event.dart';
part 'translator_state.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  final TranslatorRepository _translatorRepository;

  String translatedText = '';
  TranslatorLanguage? selectedLanguage;
  List<TranslatorLanguage> languageList = [];

  TranslatorBloc(this._translatorRepository) : super(TranslatorInitial()) {
    on<OnTranslateEvent>((event, emit) async {
      emit(TranslatorLoadingState());

      try {
        String response = await _translatorRepository.translate(
            event.text, event.sourceLanguageCode);
        translatedText = response;
        emit(TranslatorLoadedState(response));
      } catch (e) {
        debugPrint(e.toString());
        emit(TranslatorErrorState(e.toString()));
      }
    });

    on<OnLoadLanguageListTranslatorEvent>((event, emit) async {
      emit(TranslatorLanguageListLoadingState());

      try {
        List<TranslatorLanguage> list =
            await _translatorRepository.getAllLanguageList();
        languageList = list;
        emit(TranslatorLanguageListLoadedState(list));
      } catch (e) {
        debugPrint(e.toString());
        emit(TranslatorErrorState(e.toString()));
      }
    });

    on<OnSelectLanguageCodeTranslatorEvent>((event, emit) async {
      selectedLanguage = languageList
          .where((element) => element.languageCode == event.languageCode)
          .first;
      emit(TranslatorSelectedState(selectedLanguage));
    });

    on<OnClearTranslatorEvent>((event, emit) async {
      selectedLanguage = null;
      languageList.clear();
    });
  }
}
