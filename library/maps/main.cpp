// 1. How does size and capacity grow?
// 2. reserve
// 3. Use a ranged for-loop to write display(vec)
// 4. Erase all of the even numbers in the vector

#include <iostream>
#include <cstdlib>
#include <map>

int main() {
  std::map<int, int> mymap;
  mymap[2] = 11;
  mymap[2] = 81;
  std::cout << mymap[2] << std::endl;
}
