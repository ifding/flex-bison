#include <iostream>
#include <sstream>
#include <cmath>
#include <cstdlib>
#include <iomanip>
#include "ast.h"
#include "symbolTable.h"

void freeAST(Node* node) {
  if ( node ) {
    BinaryNode* temp = dynamic_cast<BinaryNode*>(node);
    if ( temp ) {
      freeAST(temp->getLeft());
      freeAST(temp->getRight());
    }
    delete node;
  }
}

int IdentNode::eval() const { 
  int val = SymbolTable::getInstance().getValue(ident);
  return val;
}


AssBinaryNode::AssBinaryNode(Node* left, Node* right) : 
  BinaryNode(left, right) { 
  int res = right->eval();
  const std::string n = static_cast<IdentNode*>(left)->getIdent();
  SymbolTable::getInstance().setValue(n, res);
}


int AssBinaryNode::eval() const { 
  if (!left || !right) {
    throw "error";
  }
  int res = right->eval();

  const std::string n = static_cast<IdentNode*>(left)->getIdent();
  SymbolTable::getInstance().setValue(n, res);
  return res;
}

int AddBinaryNode::eval() const { 
  if (!left || !right) {
    throw "error";
  }
  int x = left->eval();
  int y = right->eval();
  return (x+y);
}

int SubBinaryNode::eval() const { 
  if (!left || !right) {
    throw "error";
  }
  int x = left->eval();
  int y = right->eval();
  return (x-y);
}

int MulBinaryNode::eval() const { 
  if (!left || !right) {
    throw "error";
  }
  int x = left->eval();
  int y = right->eval();
  return (x*y);
}

int DivBinaryNode::eval() const { 
  if (!left || !right) {
    throw "error";
  }
  int x = left->eval();
  int y = right->eval();
  if ( y == 0 ) {
    throw std::string("ZeroDivisionError");
  }

  return (x/y);
}

