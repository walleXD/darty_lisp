import 'package:darty_lisp/src/scanner.dart';

import 'package:test/test.dart';

void main() {
  // Scanner Tests
  group('Scanner Tests', () {
    Scanner ourScanner;

    setUp(() {
      ourScanner = Scanner();
    });

    test('Tokenize Parentesis', () {
      expect(ourScanner.tokenize('((lambda (x) x) "Lisp")'),
          ['(', '(', 'lambda', '(', 'x', ')', 'x', ')', '"Lisp"', ')']);
    });
  });
}
