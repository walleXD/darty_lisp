import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:matcher/matcher.dart';

class Token {
  Token({this.type, this.value, this.charSize});

  final String type;
  final String value;
  final int charSize;

  operator ==(t) => equals(t);

  bool equals(Token t) => t.type == type && t.value == value;

  static Token tokenizeCharacter(
          String type, String value, String input, int current) =>
      value == input[current]
          ? Token(type: type, value: value, charSize: 1)
          : Token(type: "Error", value: null, charSize: 0);

  static Token tokenizeParenOpen(String input, int current) =>
      tokenizeCharacter("paren", "(", input, current);

  static Token tokenizeParenClose(String input, int current) =>
      tokenizeCharacter("paren", ")", input, current);

  static Token tokenizePattern(
      String type, RegExp pattern, String input, int current) {
    var char = input[current];
    int consumedChar = 0;
    if (pattern.hasMatch(char)) {
      var value = "";
      while (char != null && pattern.hasMatch(char)) {
        value += char;
        consumedChar++;
        char = input[current + consumedChar];
      }

      return Token(type: type, value: value, charSize: consumedChar);
    }
    return Token(type: "EOF", value: null, charSize: 0);
  }

  static Token tokenizeNum(String input, int current) =>
      tokenizePattern("num", RegExp("[0-9]"), input, current);

  static Token tokenizeName(String input, int current) =>
      tokenizePattern("name", RegExp("[A-Za-z]"), input, current);
}

class _TokenMatcher extends Matcher {
  _TokenMatcher({@required this.token});
  final Token token;

  bool matches(item, Map matchState) {
    return item is Token && token.equals(item);
  }

  Description describe(Description description) => description;
  // .add('checking if two Tokens are equal')
  // .addDescriptionOf(collapseWhitespace(_prefix))
  // .add(' ignoring whitespace');
}

Matcher tokenEquals(m) => _TokenMatcher(token: m);

expectTokens(Token a, Token b) {
  expect(
    a.value,
    b.value,
  );
  expect(
    a.type,
    b.type,
  );
  expect(
    a.charSize,
    b.charSize,
  );
}

class Tokens extends IterableBase {
  String _program;
  set program(i) => _program = i;

  List<Token> _tokens;
  get value => _tokens;
  get iterator => _tokens.iterator;

  int _literalAtomCount = 0;
  int _numeralAtomCount = 0;
  int _parenCloseCount = 0;
  int _parenOpenCount = 0;

  void generate() {
    if (_program == null) throw ("Please initialize program");
    _tokens = [];
  }

  Token getNextToken() {}
}
