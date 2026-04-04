import 'dart:io';

void main() {
  // Input marks
  print("Enter your marks:");
  double marks = double.parse(stdin.readLineSync()!);

  int gradePoint = 0;
  String grade = "";
  String performance = "";

  // Conditions
  if (marks < 40) {
    gradePoint = 0;
    grade = "F";
    performance = "Fail";
  } else if (marks >= 40 && marks <= 49.97) {
    gradePoint = 4;
    grade = "D";
    performance = "Just Pass";
  } else if (marks >= 50 && marks <= 59.97) {
    gradePoint = 5;
    grade = "C";
    performance = "Below Average";
  } else if (marks >= 60 && marks <= 69.99) {
    gradePoint = 6;
    grade = "B";
    performance = "Average";
  } else if (marks >= 70 && marks <= 79.99) {
    gradePoint = 7;
    grade = "B+";
    performance = "Good";
  } else if (marks >= 80 && marks <= 89.99) {
    gradePoint = 8;
    grade = "A";
    performance = "Very Good";
  } else if (marks >= 90 && marks <= 99.99) {
    gradePoint = 9;
    grade = "A+";
    performance = "Excellent";
  } else if (marks == 100) {
    gradePoint = 10;
    grade = "O";
    performance = "Outstanding";
  } else {
    print("Invalid marks!");
    return;
  }

  // Output using string interpolation
  print("\nMarks: $marks");
  print("Grade Point: $gradePoint");
  print("Grade: $grade");
  print("Performance: $performance");
}
