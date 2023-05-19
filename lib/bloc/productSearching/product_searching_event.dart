part of 'product_searching_bloc.dart';

abstract class ProductSearchingEvent extends Equatable {
  const ProductSearchingEvent();

  @override
  List<Object?> get props => [];
}

class OnSearchProductEvent extends ProductSearchingEvent{
  final String productName;
  final int page;
  final int limit;

  const OnSearchProductEvent(this.productName, this.page, this.limit);
}

class OnClearProductResultsEvent extends ProductSearchingEvent{}

