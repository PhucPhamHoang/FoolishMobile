part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadingState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadedState extends CategoryState {
  final List<Category> categoryList;

  const CategoryLoadedState(this.categoryList);

  @override
  List<Object> get props => [categoryList];
}

class CategoryErrorState extends CategoryState {
  final String message;

  const CategoryErrorState(this.message);

  @override
  List<Object> get props => [message];
}
