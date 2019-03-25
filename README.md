# Darty LISP

A library for LISP developers looking for Darty expreinces.

## Usage

A simple usage example:

```dart
import 'package:darty_lisp/darty_lisp.dart';

main() {
  // Lexer to generate tokens for LISP programs
  Tokens lexer = new Tokens();
  lexer.program = '(add 2 3)';
  lexer.generate();

  lexer.prettyPrint();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/walleXD/darty_lisp/issues
