#include "common.h"
#include <fstream>

extern TreeNode *root;
extern FILE *yyin;
extern int yyparse();
extern SymbolTable* sy_root;

using namespace std;
void delsy(SymbolTable* node){
    if(node->child.empty()){
        delete node;
        return;
    }
    else{
        int size=node->child.size();
        for(int i=1;i<=size;i++){
            delsy((node->child)[size-i]);
            node->child.pop_back();
        }
        delete node;
        return;
    }
}
int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        FILE *fin = fopen(argv[1], "r");
        if (fin != nullptr)
        {
            yyin = fin;
        }
        else
        {
            cerr << "failed to open file: " << argv[1] << endl;
        }
    }
    yyparse();
    if(root != NULL) {
    	int n=0;
        root->genNodeId(n);
        root->printAST();
    }
    delsy(sy_root);
    return 0;
}
