// 1. How does size and capacity grow?
// 2. reserve
// 3. Use a ranged for-loop to write display(vec)
// 4. Erase all of the even numbers in the vector

#include <iostream>
#include <cstdlib>
#include <vector>
const int MAX = 10;

void eraseEvens(std::vector<int>& vec) {
  std::vector<int>::iterator it = vec.begin();
  while ( it != vec.end() ) {
    if ( *it % 2 == 0 ) {
      it = vec.erase(it);
    }
    else {
      ++it;
    }
  }
}

void init(std::vector<int>& vec) {
  for ( unsigned int i = 0; i < MAX; ++i) {
    vec.push_back( rand()%100 );
  }
}

void display(const std::vector<int>& vec) {
  for ( int x : vec ) {
    std::cout << x << " "; 
  }
  std::cout << std::endl;
}

int main() {
  std::vector<int> vec;
  vec.push_back(2);
  init(vec);
  display(vec);
  eraseEvens(vec);
  display(vec);
}
