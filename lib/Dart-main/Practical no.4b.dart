void main() {
  // String values
  String num1Str = "20";
  String num2Str = "5";

  // Type Conversion (String → int)
  int a= int.parse(num1Str);
  int b= int.parse(num2Str);

  print("Converted values: a = $a, b = $b");

  // ---------------- Arithmetic Operations ----------------
  print("\n--- Arithmetic Operations ---");
  print("a + b = ${a + b}");
  print("a - b = ${a - b}");
  print("a * b = ${a * b}");
  print("a / b = ${a / b}");
  print("a ~/ b = ${a ~/ b}");
  print("a % b = ${a % b}");

  // ---------------- Increment & Decrement ----------------
  print("\n--- Increment & Decrement ---");
  int x = a;

  print("Initial x = $x");

  // Pre-increment
  print("++x = ${++x}");

  // Post-increment
  print("x++ = ${x++}");
  print("After x++ = $x");

  // Pre-decrement
  print("--x = ${--x}");

  // Post-decrement
  print("x-- = ${x--}");
  print("After x-- = $x");

  // ---------------- Relational Operations ----------------
  print("\n--- Relational Operations ---");
  print("a > b = ${a > b}");
  print("a < b = ${a < b}");
  print("a == b = ${a == b}");
  print("a != b = ${a != b}");
  print("a >= b = ${a >= b}");
  print("a <= b = ${a <= b}");

  // ---------------- Logical Operations ----------------
  print("\n--- Logical Operations ---");
  bool condition1 = (a > b);
  bool condition2 = (b > 0);

  print("condition1 && condition2 = ${condition1 && condition2}");
  print("condition1 || condition2 = ${condition1 || condition2}");
  print("!condition1 = ${!condition1}");

  // ---------------- Assignment Operations ----------------
  print("\n--- Assignment Operations ---");
  num c = a;

  print("Initial c = $c");

  c += b;
  print("c += b → $c");

  c -= b;
  print("c -= b → $c");

  c *= b;
  print("c *= b → $c");

  c ~/= b;
  print("c ~/= b → $c");

  c /= b;
  print("c /= b → $c");

  c %= b;
  print("c %= b → $c");
}
