void main() {
  // Variables
  int a = 10;
  int b = 5;

  print("Initial values: a = $a, b = $b");

  // 1. Arithmetic Operators
  print("\n--- Arithmetic Operators ---");
  print("Addition (a + b): ${a + b}");
  print("Subtraction (a - b): ${a - b}");
  print("Multiplication (a * b): ${a * b}");
  print("Division (a / b): ${a / b}");
  print("Modulus (a % b): ${a % b}");

  // 2. Relational Operators
  print("\n--- Relational Operators ---");
  print("a > b: ${a > b}");
  print("a < b: ${a < b}");
  print("a == b: ${a == b}");
  print("a != b: ${a != b}");
  print("a >= b: ${a >= b}");
  print("a <= b: ${a <= b}");

  // 3. Logical Operators
  print("\n--- Logical Operators ---");
  bool x = true;
  bool y = false;
  print("x && y: ${x && y}");
  print("x || y: ${x || y}");
  print("!x: ${!x}");

  // 4. Assignment Operators
  print("\n--- Assignment Operators ---");
  int c = 20;
  print("Initial c: $c");
  c += 5;  // c = c + 5
  print("c += 5: $c");
  c -= 3;  // c = c - 3
  print("c -= 3: $c");
  c *= 2;  // c = c * 2
  print("c *= 2: $c");
  c ~/= 4; // integer division
  print("c ~/= 4: $c");

  // 5. Increment and Decrement Operators
  print("\n--- Increment & Decrement ---");
  int d = 10;
  print("Initial d: $d");

  print("Post-increment d++: ${d++}"); // uses then increments
  print("After d++: $d");

  print("Pre-increment ++d: ${++d}"); // increments then uses
  print("After ++d: $d");

  print("Post-decrement d--: ${d--}");
  print("After d--: $d");

  print("Pre-decrement --d: ${--d}");
  print("After --d: $d");
}
