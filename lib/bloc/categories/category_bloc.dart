import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../data/entity/category.dart';
import '../../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  List<Category> categoryList = [];
  String selectedCategoryName = '';

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<OnLoadCategoryEvent>((event, emit) async {
      emit(CategoryLoadingState());
      categoryList = [];

      try {
        dynamic response = await _categoryRepository.getAllCategories();

        if (response is List<Category>) {
          categoryList = response;
          emit(CategoryLoadedState(response));
        } else {
          emit(CategoryErrorState(response.toString()));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<OnSelectedCategoryEvent>((event, emit) {
      selectedCategoryName = event.selectedCategoryName;
    });

    on<OnClearSelectedCategoryEvent>((event, emit) {
      selectedCategoryName = '';
    });
  }
}
