/// List lexer
class Scanner {
  /// Provide LISP [program] as string
  Scanner({this.program});

  final String program;

  static List<String> getRawtokens(String program) => program
      .split('"')
      .asMap()
      .map((i, chunk) => i.isEven
          ? MapEntry(
              i, chunk.replaceAll(RegExp(r'\('), ' ( ').replaceAll(r')', ' ) '))
          : MapEntry(i, chunk.replaceAll(' ', '/!whitespace!/')))
      .values
      .join(' ')
      .trim()
      .split(RegExp(r'\s'))
      .map((chunk) => chunk.replaceAll(RegExp(r'/!whitespace!/'), ' '))
      .where((chunk) => chunk != '')
      .toList();

  static catagorize(List<String> tokens) {}

  static generateToken(String rawToken) {
    if (rawToken == '') {}
  }
}
