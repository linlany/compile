%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
    SymbolTable* cur=new SymbolTable;
    SymbolTable* sy_root=cur;
%}
%token T_CHAR T_INT T_STRING T_BOOL T_VOID
%token RETURN IF ELSE WHILE FOR
%token PLUASS MINASS MULASS DIVASS PLUS MINUS
%token SEMI COMMA
%token ASSIGN LOEOP GOEOP GREOP LESSOP EQOP NEQOP MUL DIV MOD AND OR NOT
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE PRINTF SCANF 


%token ID INTEGER CHAR BOOL STRING

%right ASSIGN PLUASS MINASS MULASS DIVASS 
%left OR
%left AND
%left LOEOP GOEOP GREOP LESSOP EQOP NEQOP
%left PLUS MINUS
%left MUL DIV MOD
%right NOT
%right UMINUS UPLUS
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%

program
:T ID LPAREN RPAREN statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);root->addChild($2);root->addChild($5);int n=sy_root->insert($2->var_name);$2->val_scope=sy_root;$2->val_scope_index=n;};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMI  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;$$->stmt_val="";}
| declaration SEMI {$$ = $1;}
| RETURN expr SEMI {$$ = $1;$$->addChild($2);}
| RETURN SEMI {$$ = $1;}
| IF LPAREN expr RPAREN statement ELSE statement {$$ = $1;$$->addChild($3);$$->addChild($5);$$->addChild($6);$6->addChild($7);}
| IF LPAREN expr RPAREN statement %prec LOWER_THEN_ELSE {$$ = $1;$$->addChild($3);$$->addChild($5);}
| WHILE LPAREN expr RPAREN statement {$$ = $1;$$->addChild($3);$$->addChild($5);}
| forstmt {$$=$1;}
| PRINTF LPAREN expr RPAREN SEMI {$$=$1;$$->addChild($3);}
| SCANF LPAREN ID RPAREN SEMI {
	$$=$1;
	$$->addChild($3);
	int n=cur->find($3->var_name);
	SymbolTable* t=cur;
	if(n==-1){
		while(t->pre&&n==-1){
			t=t->pre;
			n=t->find($3->var_name);
		}
		if(t->pre==NULL){
			n=t->find($3->var_name);
		}
		if(n!=-1){
			$3->val_scope=t;
			$3->val_scope_index=n;
		}
		else{
			$$->val_scope_index=-1;
		}
	}
	else{
		$3->val_scope=t;
		$3->val_scope_index=n;
	}
	}
| lb statements rb {$$ = new TreeNode(lineno, NODE_STMT);$$->addChild($2);$$->stype = STMT_LIST;}
| exprstmt {$$=$1;}
| lb rb {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;$$->stmt_val="  ";}
;
forstmt
: FOR LPAREN statement boolstmt exprassign RPAREN statement {$$=$1;$$->addChild($3);$$->addChild($4);$$->addChild($5);$$->addChild($7);}
| FOR LPAREN statement boolstmt RPAREN statement {$$=$1;$$->addChild($3);$$->addChild($4);TreeNode* node = new TreeNode(lineno, NODE_STMT);node->stype = STMT_SKIP;node->stmt_val="";$$->addChild(node);$$->addChild($6);}
;
boolstmt
: boolexpr SEMI{$$=$1;}
| SEMI {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;$$->stmt_val="";}
;
exprstmt
: expr SEMI {$$=$1;}
;
lb
: LBRACE {SymbolTable * temp=cur;cur=new SymbolTable(temp);temp->child.push_back(cur);}
;
rb
: RBRACE {SymbolTable * temp=cur;cur=temp->pre;}
;
declaration
: T ID ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->stmt_val="decl";
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;
    int n=cur->insert($2->var_name);
    $2->val_scope=cur;
    $2->val_scope_index=n;
} 
| T idlist {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->stmt_val="decl";
    node->addChild($1);
    node->addChild($2);
    $$ = node;
    TreeNode* t=$2;
    while(t){
        int n=cur->insert(t->var_name);
        t->val_scope=cur;
        t->val_scope_index=n;
        t=t->sibling;
    }
}
;
idlist
: idlist COMMA ID {$$=$1;$$->addSibling($3);}
| ID {$$=$1;}
;
expr
: ID {
	$$ = $1;
	int n=cur->find($1->var_name);
	SymbolTable* t=cur;
	if(n==-1){
		while(t->pre&&n==-1){
			t=t->pre;
			n=t->find($1->var_name);
		}
		if(t->pre==NULL){
			n=t->find($1->var_name);
		}
		if(n!=-1){
			$$->val_scope=t;
			$$->val_scope_index=n;
		}
		else{
			$$->val_scope_index=-1;
		}
	}
	else{
		$$->val_scope=t;
		$$->val_scope_index=n;
	}
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
| BOOL {
    $$ = $1;
}
| expr PLUS expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MINUS expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MUL expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr DIV expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MOD expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| boolexpr {$$=$1;}
| exprassign {$$=$1;}
| MINUS expr %prec UMINUS {$$=$1;$$->addChild($2);}
| PLUS expr %prec UPLUS {$$=$1;$$->addChild($2);}
;
boolexpr
: expr AND expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr OR expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| NOT expr {$$=$1;$$->addChild($2);}
| expr LOEOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr GOEOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr LESSOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr GREOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr EQOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr NEQOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
;
exprassign
: ID ASSIGN expr {
	$$=$2;
	$$->addChild($1);
	$$->addChild($3);
	int n=cur->find($1->var_name);
	SymbolTable* t=cur;
	if(n==-1){
		while(t->pre&&n==-1){
			t=t->pre;
			n=t->find($1->var_name);
		}
		if(t->pre==NULL){
			n=t->find($1->var_name);
		}
		if(n!=-1){
			$1->val_scope=t;
			$1->val_scope_index=n;
		}
		else{
			$1->val_scope_index=-1;
		}
	}
	else{
		$1->val_scope=t;
		$1->val_scope_index=n;
	}
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_VOID;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
