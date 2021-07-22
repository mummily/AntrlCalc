/*
 * Copyright (c) 2020-2030 by Hollysys
 *
 * discription: 
 *      The HolliAsST(StructuredText) Language parser.
 *      The version of Antlr4:
 *      a. antlr4-4.8-1-complete.jar)
 *      b. antlr4-cpp-runtime:
 *        Windows: antlr4-cpp-runtime-4.8.1
 *        Linux and others use source distribution: antlr4-cpp-runtime-4.8-source.zip (.h, .cpp)
 *
 * create by: caoliyan 185102 
 * create time: 2020-08-27
 * version: 1.0V
 */

parser grammar HolliAsSTParser;

options { tokenVocab=HolliAsSTLexer; }

prog
    : statementlist EOF
    ;

statementlist
        : statement+
        ;

// 程序段：
//      赋值语句    assignment_statement
//      函数调用    subprogram_control_statement
//      条件语句    selection_statement
//      循环语句    iteration_statement
//      空语句      ';' ( SEMI )
statement
            : SEMI
            | assignment_statement SEMI
            | subprogram_control_statement SEMI
            | selection_statement 
            | iteration_statement
            ;

/*
    A := exp
    A := B
    A := CONST
*/
assignment_statement
            : simple_variable ASSIGN expression
            | adr_variable ASSIGN expression
            | member_variable ASSIGN expression
            | net_variable ASSIGN expression
            | array_variable ASSIGN expression
            ;

subprogram_control_statement
            : fb_invocation
            | RETURN
            ;

fb_invocation
            : fb_name LPAREN parameterlist? RPAREN
            ;

selection_statement
            : if_statement
            | case_statement
            ;

/*
    IF ...    THEN ...
    ELSIF ... THEN ...
    ELSE ...END_IF
*/
if_statement
            : IF expression THEN statementlist 
                (ELSEIF expression THEN statementlist)* 
                (ELSE statementlist)? 
              END_IF
            ;

/*
CASE ... OF
...
ELSE ...
END_CASE
*/
case_statement
            : CASE expression OF 
                (case_range COLON statementlist)+ 
                (ELSE statementlist)? 
              END_CASE
            ;

case_range
            : expression (range_operator expression)*
            ;

range_operator
            : RANGE
            | COMMA
            ;

iteration_statement
            : for_statement 
            | while_statement 
            | repeat_statement 
            | exit_statement
            ;

/*
FOR ... TO ... BY ... DO
...
END_FOR
*/
for_statement
            : FOR assignment_statement 
                TO expression
                (BY expression)?
                DO statementlist
                END_FOR
            ;

while_statement
            : WHILE expression DO statementlist END_WHILE
            ;

repeat_statement
            : REPEAT statementlist UNTIL expression END_REPEAT
            ;

exit_statement
            : EXIT (SEMI)?
            ;

/*
参数列表：
    (常量、变量、表达式) 
*/
parameterlist
        : parameter (COMMA parameter)*
        ;

parameter
        : expression
        | assignment_statement
        ;

expression
   : expression (STAR | SLASH | MOD) expression

   | expression (PLUS | MINUS) expression

   | expression (LT | LE 
                | GE | GT 
                | EQUAL | NOT_EQUAL) expression

   | expression AND expression
   | expression XOR expression
   | expression OR expression

   | (PLUS | MINUS)? factor
   ;

factor
   : simple_variable
   | adr_variable
   | member_variable
   | net_variable
   | array_variable
   | LPAREN expression RPAREN
   | fb_invocation
   | HEX_DIGIT 
   | OTC_DIGIT 
   | DEC_DIGIT 
   | BIN_DIGIT
   | CONST_XWD
   | CONST_BOOL
   | CONST_XINT
   | CONST_DOUBLE
   | CONST_STRING
   | CONST_DATE
   | CONST_TIME
   | CONST_TIME_OF_DAY
   | CONST_DATE_AND_TIME
   | NOT factor
   ;

// 地址变量
adr_variable
        : CONST_DARR
        ;

// 简单变量
simple_variable
        : NORMAL_IDENTIFIER
        ;

//结构成员变量：只有简单标识符，数组必为结束(M6 数组只能是简单类型)
//case1： a.b.c.d;
//case2： a.b.c[i];
member_variable
        : NORMAL_IDENTIFIER (DOT NORMAL_IDENTIFIER)* (DOT array_variable)?
        ;

//网络变量
net_variable
        : NET_IDENTIFIER
        ;

/* 数组变量
VarName[1,2 , ...][1,3 , ...]...
*/
array_variable
        : NORMAL_IDENTIFIER (LBRACK expression (COMMA expression)* RBRACK)+
        ;

fb_name
        : NORMAL_IDENTIFIER
        ;

