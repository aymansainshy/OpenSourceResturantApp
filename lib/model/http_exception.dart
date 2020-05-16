class HttpException implements Exception {
  final String massage;

  HttpException(this.massage);

  @override
  String toString() {
    return massage;
    
    /// return super.toString(); // Instance of [HttpException] 
  }
}
