abstract class Validator {
  bool isValid(String value);
}

class RegexValidator implements Validator {
  final String regExpSource;

  const RegexValidator({required this.regExpSource});

  @override
  bool isValid(String value) {
    try {
      final regExp = RegExp(regExpSource);
      final Iterable<RegExpMatch> matches = regExp.allMatches(value);
      for (Match m in matches) {
        if (m.start == 0 && m.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw RegexValidationError(message: 'Validation Error.');
    }
  }
}

class RegexValidationError implements Exception {
  final String message;

  const RegexValidationError({
    required this.message,
  });
}
