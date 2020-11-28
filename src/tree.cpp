#include "tree.h"
void TreeNode::addChild(TreeNode* child) {
	if(this->child){
		this->child->addSibling(child);
	}
	else{
		this->child=child;
	}

}

void TreeNode::addSibling(TreeNode* sibling){
	if(this->sibling){
		this->sibling->addSibling(sibling);
	}
	else{
		this->sibling=sibling;
	}

}

TreeNode::TreeNode(int lineno, NodeType type) {
	this->lineno=lineno;
	this->nodeType=type;
}

void TreeNode::genNodeId(int &n) {
	this->nodeID=n;
	n++;
	if(this->child){
		this->child->genNodeId(n);
	}
	if(this->sibling){
		this->sibling->genNodeId(n);
	}
}

void TreeNode::printNodeInfo() {
	cout<<"line:  "<<this->lineno<<"\tnodeid: "<<this->nodeID<<"\t";
	this->printSpecialInfo();
	this->printChildrenId();
	cout<<endl;
}

void TreeNode::printChildrenId() {
	TreeNode * t=this->child;
	if(!t){
		return;
	}
	cout<<"child:[ ";
	while(t){
		cout<<t->nodeID<<"  ";
		t=t->sibling;
	}
	cout<<"]";
}

void TreeNode::printAST() {
	this->printNodeInfo();
	if(this->child){
		this->child->printAST();
	}
	if(this->sibling){
		this->sibling->printAST();
	}
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            cout<<"CONST  "<<"Type: "<<this->type->getTypeInfo()<<'\t';
            break;
        case NODE_VAR:
            cout<<"variable  "<<"name: "<<this->var_name<<'\t';
            break;
        case NODE_EXPR:
            cout<<"expression  "<<"opType: "<<this->optype2String(this->optype)<<'\t';
            break;
        case NODE_STMT:
            cout<<"statement  "<<"stmtType: "<<this->sType2String(this->stype)<<'\t';
            break;
        case NODE_TYPE:
            cout<<"type  "<<"type:"<<this->type->getTypeInfo()<<'\t';
            break;
        case NODE_PROG:
            cout<<"program\t";
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
	switch(type){
		case STMT_SKIP:
			return "SKIP";
		case STMT_DECL:
			return "DECL";
		case STMT_IF:
			return "IF";
		case STMT_ELSE:
			return "ELSE";
		case STMT_WHILE:
			return "WHILE";
		case STMT_RETURN:
			return "RETURN";
		case STMT_FOR:
			return "FOR";
		case STMT_EXPR:
			return "EXPR";
		case STMT_PRINTF:
			return "PRINTF";
		case STMT_SCANF:
			return "SCANF";
		default:
			return "error";
			break;
	}
}


string TreeNode::optype2String(OperatorType type){
	switch(type){
		case OP_EQ:
			return "OP_EQ";
		case OP_PLU_ASS:
			return "OP_PLU_ASS";
		case OP_MIN_ASS:
			return "OP_MIN_ASS";
		case OP_MUL_ASS:
			return "OP_MUL_ASS";
		case OP_DIV_ASS:
			return "OP_DIV_ASS";
		case OP_PLUSS:
			return "OP_PLUSS";
		case OP_MINUS:
			return "OP_MINUS";
		case OP_GRE:
			return "OP_GRE";
		case OP_LESS:
			return "OP_LESS";
		case OP_GOE:
			return "OP_GOE";
		case OP_LOE:
			return "OP_LOE";
		case OP_NEQ:
			return "OP_NEQ";
		case OP_MUL:
			return "OP_MUL";
		case OP_DIV:
			return "OP_DIV";
		case OP_AND:
			return "OP_AND";
		case OP_OR:
			return "OP_OR";
		case OP_NOT:
			return "OP_NOT";
		case OP_MOD:
			return "OP_MOD";
		case OP_ASSIGN:
			return "OP_ASSIGN";
		default:
			return "error";
			break;
	}
}

string TreeNode::nodeType2String (NodeType type){
    return "<>";
}
