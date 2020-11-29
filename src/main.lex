%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}


EOL	(\r\n|\r|\n)
CHAR \'.?\'
STRING \".+\"
PRINTF printf
SCANF scanf
B_TRUE true
B_FALSE false
RETURN return
IF if
ELSE else
WHILE while
FOR for

PLUASS \+=
MINASS -=
MULASS \*=
DIVASS \/=
PLUS \+
MINUS -
INTEGER [1-9]+[0-9]*|0 

ID [a-z_A-Z][a-zA-Z_0-9]*
SPACE [ \t]*
SEMI ;
COMMA ,
ASSIGN =
LOEOP <=
GOEOP >=
GREOP >
LESSOP <
EQOP ==
NEQOP !=

MUL \*
DIV \/
MOD %
AND &&
OR \|\|
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
"void" return T_VOID;

{B_TRUE} {
	TreeNode* node = new TreeNode(lineno, NODE_CONST);
	node->type = TYPE_BOOL;
	node->b_val = 1;
	yylval = node;
	return BOOL;
}
{B_FALSE} {
	TreeNode* node = new TreeNode(lineno, NODE_CONST);
	node->type = TYPE_BOOL;
	node->b_val = 0;
	yylval = node;
	return BOOL;
}

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
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}

{PRINTF} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_PRINTF;
	node->stmt_val="printf";
	yylval = node;
	return PRINTF;
}
{SCANF} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_SCANF;
	node->stmt_val="scanf";
	yylval = node;
	return SCANF;
}

{RETURN} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_RETURN;
	node->stmt_val="return";
	yylval = node;
	return RETURN;
}
{IF} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_IF;
	node->stmt_val="if";
	yylval = node;
	return IF;
}
{ELSE} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_ELSE;
	node->stmt_val="else";
	yylval = node;
	return ELSE;

}
{WHILE} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_WHILE;
	node->stmt_val="while";
	yylval = node;
	return WHILE;

}
{FOR} {
	TreeNode* node = new TreeNode(lineno, NODE_STMT);
	node->stype = STMT_FOR;
	node->stmt_val="for";
	yylval = node;
	return FOR;

}
{PLUASS} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_PLU_ASS;
	yylval = node;
	return PLUASS;

}
{MINASS} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_MIN_ASS;
	yylval = node;
	return MINASS;

}
{MULASS} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_MUL_ASS;
	yylval = node;
	return MULASS;
	}
{DIVASS} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_DIV_ASS;
	yylval = node;
	return DIVASS;
}
{PLUS} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_PLUSS;
	yylval = node;
	return PLUS;
}
{MINUS} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_MINUS;
	yylval = node;
	return MINUS;
}
{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}


{ID} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return ID;
}
{SPACE} {}
{SEMI} {
	return SEMI;
}
{COMMA} {return COMMA;}
{ASSIGN} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_ASSIGN;
	yylval = node;
	return ASSIGN;
}
{LOEOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_LOE;
	yylval = node;
	return LOEOP;
}
{GOEOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_GOE;
	yylval = node;
	return GOEOP;
}
{GREOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_GRE;
	yylval = node;
	return GREOP;
}
{LESSOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_LESS;
	yylval = node;
	return LESSOP;
}
{EQOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_EQ;
	yylval = node;
	return EQOP;
}
{NEQOP} {	
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_NEQ;
	yylval = node;
	return NEQOP;
}
{MUL} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_MUL;
	yylval = node;
	return MUL;

}
{DIV} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_DIV;
	yylval = node;
	return DIV;

}
{MOD} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_MOD;
	yylval = node;
	return MOD;

}
{AND} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_AND;
	yylval = node;
	return AND;

}
{OR} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_OR;
	yylval = node;
	return OR;

}


{NOT} {
	TreeNode* node = new TreeNode(lineno, NODE_EXPR);
	node->optype = OP_NOT;
	yylval = node;
	return NOT;

}
{LPAREN} {return LPAREN;}
{RPAREN} {return RPAREN;}
{LBRACK} {return LBRACK;}
{RBRACK} {return RBRACK;}
{LBRACE} {return LBRACE;}
{RBRACE} {return RBRACE;}

{commentbegin} {BEGIN COMMENT;}
<COMMENT>{commentelement} {}
<COMMENT>{commentend} {BEGIN INITIAL;}
{sincombegin} {BEGIN SINCOMMENT;}
<SINCOMMENT>{sincomele} {}
<SINCOMMENT>{sincomend} {BEGIN INITIAL;}
{AERROR} {std::cout<<"AERROR"<<"\t"<<yytext<<std::endl;}
%%
