part of 'translator_bloc.dart';

abstract class TranslatorState extends Equatable {
  const TranslatorState();
}

class TranslatorInitial extends TranslatorState {
  @override
  List<Object> get props => [];
}

class TranslatorLanguageListLoadingState extends TranslatorState {
  @override
  List<Object> get props => [];
}

class TranslatorLoadingState extends TranslatorState {
  @override
  List<Object> get props => [];
}

class TranslatorLanguageListLoadedState extends TranslatorState {
  final List<TranslatorLanguage> translatorLanguageList;

  const TranslatorLanguageListLoadedState(this.translatorLanguageList);

  @override
  List<Object> get props => [translatorLanguageList];
}

class TranslatorLoadedState extends TranslatorState {
  final String content;

  const TranslatorLoadedState(this.content);

  @override
  List<Object> get props => [content];
}

class TranslatorSelectedState extends TranslatorState {
  final TranslatorLanguage? selectedLanguage;

  const TranslatorSelectedState(this.selectedLanguage);

  @override
  List<Object?> get props => [selectedLanguage];
}

class TranslatorErrorState extends TranslatorState {
  final String message;

  const TranslatorErrorState(this.message);

  @override
  List<Object> get props => [message];
}