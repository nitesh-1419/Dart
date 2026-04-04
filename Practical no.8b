void area(dynamic a, [dynamic b]) {
  // Square (single parameter)
  if (b == null && a is int) {
    int squareArea = a * a;
    print("Area of Square: $squareArea");
  }

  // Circle (float/double + int)
  else if (a is double && b is int) {
    double circleArea = 3.14 * a * a;
    print("Area of Circle: $circleArea");
  }

  // Rectangle (double + double)
  else if (a is double && b is double) {
    double rectangleArea = a * b;
    print("Area of Rectangle: $rectangleArea");
  }

  // Triangle (int + double)
  else if (a is int && b is double) {
    double triangleArea = 0.5 * a * b;
    print("Area of Triangle: $triangleArea");
  }

  else {
    print("Invalid parameters!");
  }
}

void main() {
  // Function calls
  area(5);            // Square
  area(3.5, 2);       // Circle
  area(4.5, 6.5);     // Rectangle
  area(10, 5.5);      // Triangle
}
