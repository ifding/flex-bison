#include <iostream>
#include <vector>
#include <string>
#include <ctime>

class Animal {
public:
  Animal(const std::string& n) : name(n) {}
  virtual ~Animal() {}
private:
  std::string name;
};

class Bird : public Animal {
public:
  Bird(const std::string& n) : Animal(n) {}
  void chirp() const { std::cout << "chirp" << std::endl;  }
  void talk() const { std::cout << "Polly wanna cracker" << std::endl;  }
};

class Dog : public Animal {
public:
  Dog(const std::string& n) : Animal(n) {}
  void bark() const { std::cout << "Bark" << std::endl;  }
};

void makeNoise(const Animal* animal) {
  const Dog* ptr = dynamic_cast<const Dog*>(animal);
  if ( ptr ) {
    ptr->bark();
  }
  else {
    static_cast<const Bird*>(animal)->chirp();
  }
}

int main() {
  srand( time(0) );
  std::vector<Animal*> animals;
  animals.push_back(new Bird("Polly the Parrot"));
  animals.push_back(new Dog("Suicune"));
  makeNoise(animals[ rand()%2 ]);
}
