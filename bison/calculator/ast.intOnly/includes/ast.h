#pragma once

//  Declarations for a calculator that builds an AST
//  and a graphical representation of the AST.
//  by Brian Malloy

#include <string>
#include <map>

extern void yyerror(const char*);
extern void yyerror(const char*, const char);

class SymbolTable;

class Node {
public:
  Node() {}
  virtual ~Node() {}
  virtual int eval() const = 0;
};

void freeAST(Node*);

class LiteralNode : public Node {
public:
  LiteralNode(int v) : Node(), val(v) { } 
  virtual ~LiteralNode() {}
  virtual int eval() const { return val; }
private:
  int val;
};

class IdentNode : public Node {
public:
  IdentNode(const std::string id) : Node(), ident(id) { } 
  virtual ~IdentNode() {}
  const std::string getIdent() const { return ident; }
  virtual int eval() const;
private:
  std::string ident;
};

class BinaryNode : public Node {
public:
  BinaryNode(Node* l, Node* r) : Node(), left(l), right(r) {}
  virtual int eval() const = 0;
  Node* getLeft()  const { return left; }
  Node* getRight() const { return right; }
protected:
  Node *left;
  Node *right;
};

class AssBinaryNode : public BinaryNode {
public:
  AssBinaryNode(Node* left, Node* right);
  virtual int eval() const;
};

class AddBinaryNode : public BinaryNode {
public:
  AddBinaryNode(Node* left, Node* right) : BinaryNode(left, right) { }
  virtual int eval() const;
};

class SubBinaryNode : public BinaryNode {
public:
  SubBinaryNode(Node* left, Node* right) : BinaryNode(left, right) { }
  virtual int eval() const;
};

class MulBinaryNode : public BinaryNode {
public:
  MulBinaryNode(Node* left, Node* right) : BinaryNode(left, right) {}
  virtual int eval() const;
};

class DivBinaryNode : public BinaryNode {
public:
  DivBinaryNode(Node* left, Node* right) : BinaryNode(left, right) { }
  virtual int eval() const;
};

