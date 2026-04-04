import 'dart:io';

void main() {
  // Taking input
  print("Enter first number:");
  int a = int.parse(stdin.readLineSync()!);

  print("Enter second number:");
  int b = int.parse(stdin.readLineSync()!);

  print("Enter third number:");
  int c = int.parse(stdin.readLineSync()!);

  int greatest;

  // Finding greatest
  if (a >= b && a >= c) {
    greatest = a;
  } else if (b >= a && b >= c) {
    greatest = b;
  } else {
    greatest = c;
  }

  // Output
  print("Greatest number is: $greatest");
}
