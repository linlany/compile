#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"
class SymbolTable{
public:
	string sy[50];
	SymbolTable * pre=nullptr;
	vector<SymbolTable*> child;
	SymbolTable(SymbolTable* p=NULL){
		pre=p;
	}
	int find(string s){
		for(int i=0;i<50;i++){
			if(s==sy[i]){
				return i;
			}
		}
		
		return -1;
	}
	int insert(string s){
		for(int i=0;i<50;i++){
			if(sy[i].empty()){
				sy[i]=s;
				return i;
			}
		}
		return -1;
	}
};

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,
    NODE_STMT,
    NODE_PROG,
};

enum OperatorType
{
    OP_EQ,  // ==
    OP_PLU_ASS,
    OP_MIN_ASS,
    OP_MUL_ASS,
    OP_DIV_ASS,
    OP_PLUSS,
    OP_MINUS,
    OP_GRE,
    OP_LESS,
    OP_GOE,//>=
    OP_LOE,//<=
    OP_NEQ,//!=
    OP_MUL,
    OP_DIV,
    OP_AND,
    OP_OR,
    OP_NOT,
    OP_MOD,
    OP_ASSIGN,
};

enum StmtType {
    STMT_SKIP,
    STMT_DECL,
    STMT_IF,
    STMT_ELSE,
    STMT_WHILE,
    STMT_RETURN,
    STMT_FOR,
    STMT_EXPR,
    STMT_PRINTF,
    STMT_SCANF,
    STMT_LIST,
}
;

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId(int &n);

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
    string stmt_val;
    SymbolTable* val_scope=nullptr;
    int val_scope_index;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);
    static string optype2String(OperatorType type);

public:
    TreeNode(int lineno, NodeType type);
};

#endif
