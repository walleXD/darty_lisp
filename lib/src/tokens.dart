import 'dart:collection';
import 'dart:mirrors';

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
          : Token(type: "SKIP", value: null, charSize: 0);

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
    return Token(type: "SKIP", value: null, charSize: 0);
  }

  static Token skipWhiteSpace(String input, int i) =>
      RegExp(r'\s').hasMatch(input[i])
          ? Token(type: "blank", value: null, charSize: 1)
          : Token(type: "SKIP", value: null, charSize: 0);

  static Token tokenizeParenOpen(String input, int current) =>
      tokenizeCharacter("paren", "(", input, current);

  static Token tokenizeParenClose(String input, int current) =>
      tokenizeCharacter("paren", ")", input, current);

  static Token tokenizeName(String input, int current) =>
      tokenizePattern("name", RegExp("[A-Za-z]"), input, current);

  static Token tokenizeString(String input, int current) {
    var char = input[current];
    String value = "";
    int consumedChar = 0;
    if (char == '"') {
      consumedChar++;
      var char = input[current + consumedChar];
      while (char != '"') {
        value += char;
        consumedChar++;
        char = input[current + consumedChar];
      }

      return Token(type: "string", value: value, charSize: consumedChar);
    }
    return Token(type: "EOF", value: null, charSize: 0);
  }

  static Token tokenizeNum(String input, int current) =>
      tokenizePattern("num", RegExp("[0-9]"), input, current);
}

class Tokens extends IterableBase {
  String _program;
  set program(i) => _program = i;

  List<Token> _tokens = [];
  get value => _tokens;
  get iterator => _tokens.iterator;

  int _literalAtomCount = 0;
  int _numeralAtomCount = 0;
  int _parenCloseCount = 0;
  int _parenOpenCount = 0;
  int _numSum = 0;

// TODO: Add test cases for getNextToken
  static Token getNextToken(String input, int i) {
    bool tokenized = false;
    Token token;
    ClassMirror tm = reflectClass(Token);
    for (var m in tm.staticMembers.values) {
      if (m.simpleName != Symbol('tokenizeCharacter') &&
          m.simpleName != Symbol('tokenizePattern') &&
          !tokenized) {
        token = tm.invoke(m.simpleName, [input, i]).reflectee;

        if (token.type != "SKIP" && token.charSize > 0) {
          tokenized = true;
        }
      }
      if (tokenized) break;
    }
    return token;
  }

  void keepCount(Token token) {
    switch (token.type) {
      case "name":
        _literalAtomCount += 1;
        break;
      case "num":
        _numeralAtomCount += 1;
        _numSum += num.tryParse(token.value);
        break;
      case "paren":
        if (token.value == "(")
          _parenOpenCount += 1;
        else
          _parenCloseCount += 1;
        break;
      default:
        break;
    }
  }

// TODO: Add more generaic test cases
  void generate() {
    int i = 0;
    _program = _program.trim();

    while (i < _program.length) {
      Token token = getNextToken(_program, i);
      i += token.charSize;
      if (token.type != "blank") _tokens.add(token);

      keepCount(token);
    }
    if (_program.length < 1) {
      _tokens.add(Token(type: "EOF", value: null));
    }
  }

  void prettyPrint() {
    /** 
     * LITERAL ATOMS: 5, DEFUN, F23, X, PLUS, X
     * NUMERIC ATOMS: 2, 67
     * OPEN PARENTHESES: 3
     * CLOSING PARENTHESES: 3
    */
    print(
        'LITERAL ATOMS: ${this._literalAtomCount}, ${this._tokens.where((token) => token.type == "name").map((token) => token.value).join(" , ")}');
    print('NUMERIC ATOMS: ${this._numeralAtomCount}, ${this._numSum}');
    print('OPEN PARENTHESES: ${this._parenOpenCount}');
    print('CLOSE PARENTHESES: ${this._parenCloseCount}');
  }
}
