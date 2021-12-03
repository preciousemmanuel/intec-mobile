class AddressSuggestion {
  final String placeId;
  final String description;

  AddressSuggestion({this.description = "", this.placeId = ""});

  @override
  String toString() {
    return 'AddressSuggestion(description: $description, placeId: $placeId)';
  }

  toList() {}
}
