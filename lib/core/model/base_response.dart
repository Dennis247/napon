class BaseResponse {
  final bool isSucessfull;
  final String message;
  final dynamic data;

  BaseResponse(
      {required this.isSucessfull, required this.message, required this.data});
}
