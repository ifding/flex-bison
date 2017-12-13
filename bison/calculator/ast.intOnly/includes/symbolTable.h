#ifndef SYMBOLTABLE__H
#define SYMBOLTABLE__H

#include <iostream>
#include <string>
#include <map>

class SymbolTable {
public:
  static SymbolTable& getInstance();
  void setValue(const std::string& name, int val) { table[name] = val;  }
  int  getValue(const std::string& name) const;
private:
  std::map<std::string, int> table;
};

#endif
