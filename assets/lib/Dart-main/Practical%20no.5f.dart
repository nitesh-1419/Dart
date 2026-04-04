import 'dart:io';

void main() {
  String str1Text = "ABC DEF";

  for (int i = 0; i < str1Text.length; i++) {
    String ch = str1Text[i];
    print("$ch -> ${ch.codeUnitAt(0)}");
  }
}
