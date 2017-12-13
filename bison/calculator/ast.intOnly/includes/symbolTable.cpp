#include "symbolTable.h"

SymbolTable& SymbolTable::getInstance() {
  static SymbolTable instance;
  return instance;
}

int SymbolTable::getValue(const std::string& name) const {
  std::map<std::string, int>::const_iterator it = table.find(name);
  if ( it == table.end() ) throw name+std::string(" not found");
  return it->second;
}

