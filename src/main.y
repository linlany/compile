%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL 
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


%%

program
: T_INT ID LPAREN RPAREN statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMI  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMI {$$ = $1;}
| RETURN expr SEMI {$$ = $1;$$->addChild($2);}
| IF LPAREN expr RPAREN statement ELSE statement {$$ = $1;$$->addChild($3);$$->addChild($5);$$->addChild($6);$6->addChild($7);}
| IF LPAREN expr RPAREN statement {$$ = $1;$$->addChild($3);$$->addChild($5);}
| WHILE LPAREN expr RPAREN statement {$$ = $1;$$->addChild($3);$$->addChild($5);}
| FOR LPAREN statement SEMI expr SEMI statement SEMI RPAREN statement {$$=$1;$$->addChild($3);addChild($5);addChild($7);addChild($10);}
| expr SEMI {TreeNode* node = new TreeNode($1->lineno, NODE_STMT);node->stype = STMT_EXPR;node->addChild($1);$$=node;}
| PRINTF LPAREN STRING RPAREN SEMI {$$=$1;$$->addChild($3);}
| SCANF LPAREN ID RPAREN SEMI {$$=$1;$$->addChild($3);}
| lb statements rb {$$=$2;}
;
lb
: LBRACE
;
rb
: RBRACE
;
declaration
: T ID ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T ID {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

expr
: ID {
    $$ = $1;
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
| expr PLUS expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MINUS expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MUL expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr DIV expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr MOD expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr AND expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr OR expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| NOT expr {$$=$1;$$->addChild($2);}
| ID ASSIGN expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| MINUS expr %prec UMINUS {$$=$1;$$->addChild($2);}
| PLUS expr %prec UPLUS {$$=$1;$$->addChild($2);}
| expr LOEOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr GOEOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr LESSOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr GREOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr EQOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
| expr NEQOP expr {$$=$2;$$->addChild($1);$$->addChild($3);}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}
