class BackendException implements Exception {
  List<String> errorMessages;
  BackendException(this.errorMessages);

  @override
  String toString() {
    return errorMessages.join('');
  }
}
