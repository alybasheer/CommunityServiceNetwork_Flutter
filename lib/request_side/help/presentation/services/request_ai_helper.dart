class RequestAiHelper {
  static String enhanceDescription(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final normalized = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    final withPeriod = normalized.endsWith('.') ? normalized : '$normalized.';

    return withPeriod[0].toUpperCase() + withPeriod.substring(1);
  }
}
