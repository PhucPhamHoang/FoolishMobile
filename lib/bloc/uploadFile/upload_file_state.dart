part of 'upload_file_bloc.dart';

abstract class UploadFileState extends Equatable {
  const UploadFileState();
}

class UploadFileInitial extends UploadFileState {
  @override
  List<Object> get props => [];
}

class UploadFileUploadingState extends UploadFileState {
  @override
  List<Object> get props => [];
}

class UploadFileUploadedState extends UploadFileState {
  final String url;

  const UploadFileUploadedState(this.url);

  @override
  List<Object> get props => [url];
}

class UploadFileErrorState extends UploadFileState {
  final String message;

  const UploadFileErrorState(this.message);

  @override
  List<Object> get props => [message];
}