part of 'upload_file_bloc.dart';

abstract class UploadFileEvent extends Equatable {
  const UploadFileEvent();

  @override
  List<Object> get props => [];
}

class OnUploadFileEvent extends UploadFileEvent{
  final File uploadFile;
  final bool isCustomer;
  final bool isDelivery;

  const OnUploadFileEvent(this.uploadFile, {this.isCustomer = false, this.isDelivery = false});
}