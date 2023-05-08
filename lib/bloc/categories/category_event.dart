part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class OnLoadCategoryEvent extends CategoryEvent{
  @override
  List<Object?> get props => [];
}

class OnClearSelectedCategoryEvent extends CategoryEvent{
  @override
  List<Object?> get props => [];
}

class OnSelectedCategoryEvent extends CategoryEvent{
  final String selectedCategoryName;

  const OnSelectedCategoryEvent(this.selectedCategoryName);

  @override
  List<Object?> get props => [];
}
