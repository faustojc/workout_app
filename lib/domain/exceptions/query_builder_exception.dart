class QueryBuilderException implements Exception {
  final String message;

  QueryBuilderException(this.message);

  @override
  String toString() => 'QueryBuilderException: $message';
}
