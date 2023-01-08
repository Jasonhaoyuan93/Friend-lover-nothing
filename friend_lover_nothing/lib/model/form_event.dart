import 'dart:io';

class FormDataEvent {
  String? eventTitle;
  List<String>? description;
  List<File>? imageEvent;
  File? videoFile;

  FormDataEvent({
    this.eventTitle,
    this.description,
    this.imageEvent,
    this.videoFile,
  });
}
