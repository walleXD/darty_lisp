class Scanner {
  List<String> _programTokens;

  List<String> tokenize(String program) {
    _programTokens = program
        .replaceAll(RegExp(r"\("), '( ')
        .replaceAll(RegExp(r"\)"), ' )')
        .trim()
        .split(' ');

    return _programTokens;
  }
}
