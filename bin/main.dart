import 'package:darty_lisp/darty_lisp.dart';

main(List<String> args) {
  print(args);

  Tokens tokens = Tokens();
  tokens.program = '(add 2 3)';

  tokens.generate();
  tokens.prettyPrint();
}
