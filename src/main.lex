%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}


EOL	(\r\n|\r|\n)
CHAR \'.?\'
STRING \".+\"

RETURN return
IF if
ELSE else
WHILE while
PLUASS \+=
MINASS -=
MULASS \*=
DIVASS \/=
PLUS \+
MINUS -
INTEGER [1-9]+[0-9]*|0 
FLOAT   [0-9]+\.[0-9]*  
ID [a-z_A-Z][a-zA-Z_0-9]*
SPACE [ \t]*
SEMI ;
COMMA ,
ASSIGN =
RELOP >|<|>=|<=|==|!=
MUL \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT !
LPAREN \(
RPAREN \)
LBRACK \[
RBRACK \]
LBRACE \{
RBRACE \}
commentbegin "/*"
commentelement .|\n
commentend "*/"
sincombegin \/\/
sincomele .
sincomend \n

AERROR .
%x COMMENT
%x SINCOMMENT
%%


"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;




{STRING} {
	TreeNode* node = new TreeNode(lineno, NODE_CONST);
	node->type = TYPE_STRING;
	string s = yytext;
	node->str_val = s.substr(1,s.length()-2);
	yylval = node;
	return STRING;
}

{EOL} lineno++;
{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->int_val = yytext[1];
    yylval = node;
    return CHAR;
}



{RETURN} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_SKIP;
	node->stmt_val="return";
	yylval = node;
	return RETURN；
}
{IF} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_CONDI;
	node->stmt_val="if";
	yylval = node;
	return RETURN；
}
{ELSE} {std::cout<<"ELSE"<<"\t"<<yytext<<std::endl;}
{WHILE} {std::cout<<"WHILE"<<"\t"<<yytext<<std::endl;}
{PLUASS} {std::cout<<"PLUASS"<<"\t"<<yytext<<std::endl;}
{MINASS} {std::cout<<"MINASS"<<"\t"<<yytext<<std::endl;}
{MULASS} {std::cout<<"MULASS"<<"\t"<<yytext<<std::endl;}
{DIVASS} {std::cout<<"DIVASS"<<"\t"<<yytext<<std::endl;}
{PLUS} {std::cout<<"PLUS"<<"\t"<<yytext<<std::endl;}
{MINUS} {std::cout<<"MINUS"<<"\t"<<yytext<<std::endl;}
{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{FLOAT} {std::cout<<"FLOAT"<<"\t"<<yytext<<"\t"<<atof(yytext)<<std::endl;}
{ID} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}
{SPACE} {}
{SEMI} {std::cout<<"SEMI"<<"\t"<<yytext<<std::endl;}
{COMMA} {std::cout<<"COMMA"<<"\t"<<yytext<<std::endl;}
{ASSIGN} {std::cout<<"ASSIGN"<<"\t"<<yytext<<std::endl;}
{RELOP} {std::cout<<"RELOP"<<"\t"<<yytext<<std::endl;}
{MUL} {std::cout<<"MUL"<<"\t"<<yytext<<std::endl;}
{DIV} {std::cout<<"DIV"<<"\t"<<yytext<<std::endl;}
{AND} {std::cout<<"AND"<<"\t"<<yytext<<std::endl;}
{OR} {std::cout<<"OR"<<"\t"<<yytext<<std::endl;}
{DOT} {std::cout<<"DOT"<<"\t"<<yytext<<std::endl;}

{NOT} {std::cout<<"NOT"<<"\t"<<yytext<<std::endl;}
{LPAREN} {std::cout<<"LPAREN"<<"\t"<<yytext<<std::endl;}
{RPAREN} {std::cout<<"RPAREN"<<"\t"<<yytext<<std::endl;}
{LBRACK} {std::cout<<"LBRACK"<<"\t"<<yytext<<std::endl;}
{RBRACK} {std::cout<<"RBRACK"<<"\t"<<yytext<<std::endl;}
{LBRACE} {std::cout<<"LBRACE"<<"\t"<<yytext<<std::endl;table* temp=curt;curt=new table(temp);}
{RBRACE} {std::cout<<"RBRACE"<<"\t"<<yytext<<std::endl;table* temp=curt;curt=temp->pre;}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
{sincombegin} {BEGIN SINCOMMENT;}
<SINCOMMENT>{sincomele} {}
<SINCOMMENT>{sincomend} {BEGIN INITIAL;}
{AERROR} {std::cout<<"AERROR"<<"\t"<<yytext<<std::endl;}
%%
