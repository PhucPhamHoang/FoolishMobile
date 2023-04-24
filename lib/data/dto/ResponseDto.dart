import 'package:json_annotation/json_annotation.dart';

part 'ResponseDto.g.dart';

@JsonSerializable()
class ResponseDto {
  final String result;
  final dynamic content;

  ResponseDto(this.result, this.content);

  factory ResponseDto.fromJson(Map<String, dynamic> json) => _$ResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDtoToJson(this);

  @override
  String toString() {
    return 'ResponseDto{result: $result, content: $content}';
  }
}