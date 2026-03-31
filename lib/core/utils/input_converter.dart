/// Small utility class to convert/validate raw inputs for usecases
class InputConverter {
  /// Parse unsigned integer from string, returns null on invalid input
  int? parseUnsignedInt(String input) {
    final value = int.tryParse(input);
    if (value == null || value < 0) return null;
    return value;
  }

  /// Trim and normalize a string; returns null if empty after trim
  String? normalizeNonEmpty(String? input) {
    if (input == null) return null;
    final trimmed = input.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
