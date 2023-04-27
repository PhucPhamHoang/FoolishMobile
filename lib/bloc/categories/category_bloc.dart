import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/entity/Category.dart';
import '../../repository/CategoryRepository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  List<Category> categoryList = [];

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<OnLoadCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      categoryList = [];

      try{
        List<Category> list = await _categoryRepository.getAllCategories();
        categoryList = list;
        emit(CategoryLoadedState(list));
      }
      catch(e){
        print(e);
        emit(CategoryErrorState(e.toString()));
      }
    });
  }
}
