#include <iostream>
#include <vector>
#include <string>

class Shape {
public:
  Shape(const std::string& n) : name(n) {}
  const std::string& getName() const { return name; }
  virtual float area() const = 0;
  virtual void doSomething() const { std::cout << "WHY" << std::endl; }
private:
  std::string name;
};

class Circle : public Shape {
public:
  Circle(const std::string& n, float r) : Shape(n), radius(r) {}
  virtual float area() const { return 3.14*radius*radius; } 
private:
  float radius;
};

class Rectangle : public Shape {
public:
  Rectangle(const std::string& n, int w, int h) : 
    Shape(n), width(w), height(h) {}
  virtual float area() const { 
    doSomething();
    return width*height; 
  } 
private:
  int width;
  int height;
};

void printAreas(const std::vector<Shape*>& shapes) {
  for ( Shape* shape : shapes ) {
    std::cout << shape->area() << std::endl;
  }
}

int main() {
  std::vector<Shape*> shapes;
  shapes.push_back( new Circle("circle", 5.0) );
  shapes.push_back( new Rectangle("Rectangle", 5, 6) );
  shapes.push_back( new Circle("circle", 5.0) );
  printAreas(shapes);
}
