/*
 * Copyright (c) 2020-2030 by Hollysys
 *
 * discription: 
 *      The HolliAsSTVar(StructuredText) Language parsLexerer.
 *      The version of Antlr4:
 *      a. antlr4-4.8-1-complete.jar)
 *      b. antlr4-cpp-runtime:
 *        Windows: antlr4-cpp-runtime-4.8.1
 *        Linux and others use source distribution: antlr4-cpp-runtime-4.8-source.zip (.h, .cpp)
 *
 * create by: caoliyan 185102 
 * create time: 2020-10-23
 * version: 1.0V
 */

lexer grammar HolliAsSTVarLexer;

// Symbol def
PLUS : '+';
MINUS : '-';
SEMI  : ';';
COMMA : ',';
COLON : ':' ;
DOT   : '.' ;
RANGE : '..' ;
LPAREN : '(' ;
RPAREN : ')' ;
LBRACK : '[' ;
RBRACK : ']' ;
ASSIGN : ':=';

// Keywords
//      POU类型（PROGRAMPRG, FUNCTION_BLOCK:FB, FUNCTION:FUN)
PROGRAM : P_ R_ O_ G_ R_ A_ M_;
FUNCTION_BLOCK : F_ U_ N_ C_ T_ I_ O_ N_ '_' B_ L_ O_ C_ K_;
FUNCTION : F_ U_ N_ C_ T_ I_ O_ N_;

//      变量类别（VAR:local_var, VAR_INPUT:input...)
VAR : V_ A_ R_;
VAR_INPUT : V_ A_ R_ '_' I_ N_ P_ U_ T_;
VAR_IN_OUT : V_ A_ R_ '_' I_ N_ '_' O_ U_ T_;
VAR_OUTPUT : V_ A_ R_ '_' O_ U_ T_ P_ U_ T_;
END_VAR : E_ N_ D_ '_' V_ A_ R_;

//      变量类型
//              a. 基本类型 VT_BASEDB
BOOL  : B_ O_ O_ L_ ;
BYTE  : B_ Y_ T_ E_ ;
WORD  : W_ O_ R_ D_ ;
DWORD : D_ W_ O_ R_ D_ ;
SINT  : S_ I_ N_ T_ ;
USINT : U_ S_ I_ N_ T_ ;
INT   : I_ N_ T_ ;
UINT  : U_ I_ N_ T_ ;
DINT  : D_ I_ N_ T_ ;
UDINT : U_ D_ I_ N_ T_ ;
TIME  : T_ I_ M_ E_ ;
DATE  : D_ A_ T_ E_ ;
TOD   : T_ O_ D_ ;
DT    : D_ T_ ;
REAL  : R_ E_ A_ L_ ;
LREAL : L_ R_ E_ A_ L_ ;
BIT   : B_ I_ T_ ;

//              b. string类型 VT_STRINGDB
STRING: S_ T_ R_ I_ N_ G_;

//              c. 数组类型 VT_ARRAYDB
ARRAY : A_ R_ R_ A_ Y_;

//              d. 指针类型 POINTER
POINTER: P_ O_ I_ N_ T_ E_ R_;

//              e. 自定义类型

// Other Key words
OF: O_ F_;
TO: T_ O_;

// Num Type Def
//      Type Keys declare
fragment BYTE_ : B_ Y_ T_ E_;
fragment WORD_ : W_ O_ R_ D_;
fragment DWORD_ : D_ W_ O_ R_ D_;
fragment BOOL_ : B_ O_ O_ L_;
fragment SINT_ : S_ I_ N_ T_;
fragment INT_ : I_ N_ T_ ;
fragment DINT_ : D_ I_ N_ T_;
fragment USINT_ : U_ S_ I_ N_ T_;
fragment UINT_ : U_ I_ N_ T_;
fragment UDINT_ : U_ D_ I_ N_ T_;
fragment REAL_ : R_ E_ A_ L_;
fragment LREAL_ : L_ R_ E_ A_ L_;
fragment TIME_ : T_ I_ M_ E_;
fragment TIME_OF_DAY_ : T_ I_ M_ E_ '_' O_ F_ '_' D_ A_ Y_;
fragment DATE_ : D_ A_ T_ E_;
fragment DATE_AND_TIME_ : D_ A_ T_ E_ A_ N_ D_ '_' T_ I_ M_ E_;

//      Big Type declare
fragment BT_WD_TYPE_: BYTE_ | WORD_ | DWORD_;
fragment XINT_TYPE_: SINT_ | INT_ | DINT_ | USINT_ | UINT_ | UDINT_;
fragment DOUBLE_TYPE_: LREAL_ | REAL_;

//      Values def
fragment BOOL_LITERAL: T_ R_ U_ E_ | F_ A_ L_ S_ E_ | '0' | '1';

//      Num Type declare
fragment BinDigit_: '0' | '1';
fragment OtcDigit_: [0-7];
fragment DecDigit_: [0-9];
fragment HexDigit_: [0-9a-fA-F];

//      Num Type Def(16\10\8\2)
HEX_DIGIT: '16#'('+' | '-')?HexDigit_+;
DEC_DIGIT: DecDigit_+;

OTC_DIGIT: '8#'('+' | '-')?OtcDigit_+;
BIN_DIGIT: '2#'BinDigit_+;

//      const num type def
fragment NUM_CONST_: HEX_DIGIT | OTC_DIGIT | DEC_DIGIT | BIN_DIGIT;

CONST_XWD: BT_WD_TYPE_ '#' NUM_CONST_;

CONST_BOOL
        : BOOL_ '#' BOOL_LITERAL
        | BOOL_LITERAL
        ;

CONST_XINT: XINT_TYPE_ '#' ( BIN_DIGIT
                            | DEC_DIGIT
                            | OTC_DIGIT
                            | HEX_DIGIT
                            | );

// 常量
// a.科学计数法: +/- 12.12e15; 12.12e-/+15; 
CONST_DOUBLE: (DOUBLE_TYPE_ '#')? (DecDigit_+)('.'(DecDigit_+))? (E_ ('+'|'-')?DecDigit_+)? ;

// b. time常量: time#2D4H59M12S33MS
CONST_TIME
        : ((T_ I_ M_ E_) | T_)  '#'
                (DecDigit_+('.'DecDigit_+)?(D_))?
                (DecDigit_+('.'DecDigit_+)?(H_))?
                (DecDigit_+('.'DecDigit_+)?(M_))?
                (DecDigit_+('.'DecDigit_+)?(S_))?
                (DecDigit_+('.'DecDigit_+)?((M_ S_)))?
        ;

// c. time_of_day常量: (time_of_day/tod)#11:12:12.10;
CONST_TIME_OF_DAY
        : ((T_ I_ M_ E_ '_' O_ F_ '_' D_ A_ Y_) | (T_ O_ D_)) '#'
                DecDigit_+ COLON DecDigit_+ COLON DecDigit_+ (DOT DecDigit_+)?
        ;

// d. date常量: (Date/D)#2020-08-26
CONST_DATE
        : ((D_ A_ T_ E_) | D_) '#'
                DecDigit_+ MINUS DecDigit_+ MINUS DecDigit_+
        ;

// e.date_and_time常量: (Date_And_Time/DT)#2020-08-26-10:12:12.12;
CONST_DATE_AND_TIME
        : ((D_ A_ T_ E_ '_' A_ N_ D_ '_' T_ I_ M_ E_) | (D_ T_)) '#'
                DecDigit_+ MINUS DecDigit_+ MINUS DecDigit_+ MINUS
                DecDigit_+ COLON DecDigit_+ COLON DecDigit_+ (DOT DecDigit_+)?
        ;

// f. string常量
CONST_STRING
            : '\'' .*?  '\''
            ;

// 6. 此文法无直接地址变量CONST_DARR

// 7 变量
// a. 此文法无网络变量

// b. 普通标识符（变量、函数名等）
//可以"数字"(Hollysys)/"字母”(IEC61131-3)/"下划线”(IEC61131-3)为先导
//可以连续"_"为先导(Hollysys)
//不可全"数字"(Hollysys)
NORMAL_IDENTIFIER
                : ([A-Z]|[a-z])([A-Z]|[a-z]|[0-9]|'_')*
                | ([0-9])+([A-Z]|[a-z])
                | ([0-9])+([A-Z]|[a-z]|'_')+([A-Z]|[a-z]|[0-9]|'_')*
                | ('_')+([A-Z]|[a-z]|[0-9])+([A-Z]|[a-z]|[0-9]|'_')*
                ;


// 8. Others(Whitespace, comments, NewLine)
BLOCK_COMMENT
        : '(*' .*? '*)'
        ;

// LINE_COMMENT:   '//' ~[\r\n]* -> channel(HIDDEN);

WHITESPACE: [ \t]+ -> skip;

NEW_LINE: ('\r' '\n'? | '\n') -> skip;

LINE_CONTINUATION : [ \t]+ '\r'? '\n' -> skip;

OTHER_CHARS : (~[\u0000-\u007F\uD800-\uDBFF]+
            | [\uD800-\uDBFF]+
            | [\uDC00-\uDFFF]+) -> skip;


// Ignore case declare
fragment A_ : ('a' | 'A');
fragment B_ : ('b' | 'B');
fragment C_ : ('c' | 'C');
fragment D_ : ('d' | 'D');
fragment E_ : ('e' | 'E');
fragment F_ : ('f' | 'F');
fragment G_ : ('g' | 'G');
fragment H_ : ('h' | 'H');
fragment I_ : ('i' | 'I');
fragment J_ : ('j' | 'J');
fragment K_ : ('k' | 'K');
fragment L_ : ('l' | 'L');
fragment M_ : ('m' | 'M');
fragment N_ : ('n' | 'N');
fragment O_ : ('o' | 'O');
fragment P_ : ('p' | 'P');
fragment Q_ : ('q' | 'Q');
fragment R_ : ('r' | 'R');
fragment S_ : ('s' | 'S');
fragment T_ : ('t' | 'T');
fragment U_ : ('u' | 'U');
fragment V_ : ('v' | 'V');
fragment W_ : ('w' | 'W');
fragment X_ : ('x' | 'X');
fragment Y_ : ('y' | 'Y');
fragment Z_ : ('z' | 'Z');
