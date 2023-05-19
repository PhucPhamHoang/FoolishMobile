part of 'translator_bloc.dart';

abstract class TranslatorEvent extends Equatable {
  const TranslatorEvent();

  @override
  List<Object> get props => [];
}

class OnTranslateEvent extends TranslatorEvent {
  final String text;
  final String sourceLanguageCode;

  const OnTranslateEvent(this.text, this.sourceLanguageCode);
}

class OnLoadLanguageListTranslatorEvent extends TranslatorEvent {}

class OnClearTranslatorEvent extends TranslatorEvent {}

class OnSelectLanguageCodeTranslatorEvent extends TranslatorEvent {
  final String languageCode;

  const OnSelectLanguageCodeTranslatorEvent(this.languageCode);
}