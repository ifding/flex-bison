// 1. size v capacity
// 2. value semantics
// 3. push_back 
// 4. reserve 
// 5. emplace_back
// 6. explicit
// 7. ranged for loops

#include <iostream>
#include <vector>
#include <cstdlib>
#include <algorithm>

class Number {
public:
  Number() : number(0) { std::cout << "default" << std::endl; }
  explicit Number(int n) : number(n) { std::cout << "convert" << std::endl; }
  Number(const Number& a) : number(a.number) {
    std::cout << "copy" << std::endl;
  }
  Number& operator=(const Number& rhs) {
    if ( this != &rhs ) {
      number = rhs.number;
    }
    std::cout << "assign" << std::endl;
    return *this;
  }
  int getNumber() const { return number; }
private:
  int number;
};
std::ostream& operator<<(std::ostream& out, const Number& n) {
  return out << n.getNumber();
}

int main() {
  std::vector<Number> vec;
  vec.reserve(5);
  vec.push_back(Number(7));
  vec.push_back(Number(79));
  vec.push_back(Number(79));
  vec.push_back(Number(79));
  vec.push_back(Number(79));
  vec.push_back(Number(79));
  std::cout << vec.size() << ", " << vec.capacity() << std::endl;
}
