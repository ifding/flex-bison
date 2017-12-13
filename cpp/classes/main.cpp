#include <iostream>
#include <cstring>

class string {
public:
  string() : buf(new char[1]) { 
    buf[0] = '\0'; 
    std::cout << "default" << std::endl;
  }
  explicit string(const char* s) : buf(new char[strlen(s)+1]) {
    strcpy(buf, s);
    std::cout << "convert" << std::endl;
  }
  string(const string& s) : buf(new char[strlen(s.buf)+1]) {
    strcpy(buf, s.buf);
    std::cout << "copy" << std::endl;
  }
  ~string() { 
    std::cout << "delete: " << buf << std::endl; 
    delete [] buf; 
  }
  char* getBuf() const { return buf; }
  string& operator=(const string& rhs) {
    if ( this == &rhs ) return *this;
    delete [] buf;
    buf = new char[strlen(rhs.buf)+1];
    strcpy(buf, rhs.buf);
    std::cout << "assign" << std::endl;
    return *this;
  }
  friend std::ostream& operator<<(std::ostream&, const string&);
private:
  char* buf;
};
std::ostream& operator<<(std::ostream& out, const string& s) {
  return out << s.buf;
}

class Test {
public:
  Test(const char* n) : name(n) { }
private:
  string name;
};

int main() {
  Test test("Lapras");
  string d("Arcanine");
  std::cout << d << std::endl;
}
