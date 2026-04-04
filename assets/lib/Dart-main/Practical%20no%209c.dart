class Calculator {
  int _no1 = 0;   // private variable
  int _no2 = 0;   // private variable
  int _result = 0; // private variable

  // Setter for no1
  void setNo1(int n1) {
    _no1 = n1;
  }

  // Setter for no2
  void setNo2(int n2) {
    _no2 = n2;
  }

  // Getter for result
  int getResult() {
    return _result;
  }

  // Display function
  void display() {
    print("The result is $_result");
  }

  // Addition function
  void addition() {
    _result = _no1 + _no2;
    display();
  }
}

void main() {
  Calculator c1 = Calculator();

  c1.setNo1(10);
  c1.setNo2(26);

  c1.addition();
}
