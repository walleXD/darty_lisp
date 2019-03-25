import 'package:test/test.dart';

import 'package:darty_lisp/src/tokens.dart';

void main() {
  group('Tokenizer', () {
    Tokens _ourTokens;
    Token _ourToken;

    setUp(() {
      _ourTokens = Tokens();
      _ourToken = Token();
    });

    test('tokenizeParenOpen generates token for (', () {
      expectTokens(Token.tokenizeParenOpen('(', 0),
          Token(type: "paren", value: '(', charSize: 1));
    });

    test('tokenizeParenClose generates token for )', () {
      expectTokens(Token.tokenizeParenClose(')', 0),
          Token(type: 'paren', value: ')', charSize: 1));
    });

    test('Generate tokens for numbers', () {
      expectTokens(Token.tokenizeNum('222aaa', 0),
          Token(type: 'num', value: '222', charSize: 3));
    });

    test('Generate tokens for name', () {
      expectTokens(Token.tokenizeName('aaa2222', 0),
          Token(type: 'name', value: 'aaa', charSize: 3));
    });

    test('Generate tokens for name with space', () {
      expectTokens(Token.tokenizeName('Hello World', 0),
          Token(type: 'name', value: 'Hello', charSize: 5));
    });
  });
}
