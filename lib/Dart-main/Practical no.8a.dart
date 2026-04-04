 import 'dart:io';

// Function to add two numbers
int addNumbers(int num1, int num2) {
  return num1 + num2;
}

void main() {
  // Taking input from user
  print("Enter a number:");
  int userNumber = int.parse(stdin.readLineSync()!);

  // Defining another integer
  int fixedNumber = 10;

  // Calling function
  int result = addNumbers(userNumber, fixedNumber);

  // Display result using string interpolation
  print("Sum of $userNumber and $fixedNumber is: $result");
}
