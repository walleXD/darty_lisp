class Scanner {
  List<String> _programTokens;

  List<String> tokenize(String program) {
    _programTokens =
        program.replaceAll('(', '( ').replaceAll(')', ' )').trim().split(' ');

    return _programTokens;
  }
}
