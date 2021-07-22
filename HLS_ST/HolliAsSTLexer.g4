/*
 * Copyright (c) 2020-2030 by Hollysys
 *
 * discription: 
 *      The HolliAsST(StructuredText) Language parsLexerer.
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

lexer grammar HolliAsSTLexer;

// Symbol def
PLUS : '+';
MINUS : '-';
STAR : '*';
SLASH : '/';
SEMI : ';';
COMMA : ',';
COLON : ':' ;
ASSIGN : ':=';
DOT : '.' ;
RANGE : '..' ;
LPAREN : '(' ;
RPAREN : ')' ;
LBRACK : '[' ;
RBRACK : ']' ;
EQUAL : '=' ;
LT : '<' ;
LE : '<=' ;
GE : '>=' ;
GT : '>' ;
NOT_EQUAL : '<>' ;

// Keywords
//      Control Keys Def
IF : I_ F_ ;
THEN : T_ H_ E_ N_ ;
ELSEIF : E_ L_ S_ (E_)? I_ F_;
ELSE : E_ L_ S_ E_ ;
END_IF : E_ N_ D_ '_' I_ F_;
CASE : C_ A_ S_ E_ ;
OF : O_ F_ ;
END_CASE : E_ N_ D_ '_' C_ A_ S_ E_;
FOR : F_ O_ R_;
TO : T_ O_ ;
BY : B_ Y_ ;
DO : D_ O_ ;
END_FOR : E_ N_ D_ '_' F_ O_ R_;
WHILE : W_ H_ I_ L_ E_;
END_WHILE : E_ N_ D_ '_' W_ H_ I_ L_ E_;
REPEAT : R_ E_ P_ E_ A_ T_;
END_REPEAT : E_ N_ D_ '_' R_ E_ P_ E_ A_ T_;
UNTIL : U_ N_ T_ I_ L_;
RETURN : R_ E_ T_ U_ R_ N_;
EXIT : E_ X_ I_ T_;

//      Operation Keys Def
XOR : X_ O_ R_ ;
AND : A_ N_ D_ | '&';
OR : O_ R_ ;
MOD : M_ O_ D_ ;
NOT : N_ O_ T_ ;

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
                            | ('+'|'-')?DEC_DIGIT
                            | OTC_DIGIT
                            | HEX_DIGIT
                            | );

// 常量
// a.科学计数法: +/- 12.12e15; 12.12e-/+15; 
CONST_DOUBLE: DOUBLE_TYPE_ '#'('+'|'-')?(DecDigit_+)('.'(DecDigit_+))? (E_ ('+'|'-')?DecDigit_+)? 
                | (DecDigit_+)('.'(DecDigit_+))? (E_ ('+'|'-')?DecDigit_+)? ;

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

// 6. 直接地址变量(X操作：取该地址首起第m [0,7]位)
CONST_DARR
            : '%' ([A-Z]|[a-z]) X_ [0-9]+ '.' [0-7]
            | '%' ([A-Z]|[a-z])(B_|W_|D_)[0-9]+;


// 7 变量
// a. 网络变量(目前M6 IDE支持'[' 数组/指针等复杂类型需要重新声明)
NET_IDENTIFIER:[0-9]+'@'(([0-9])*([A-Z]|[a-z]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*('['((([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*('['((([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*)((' ')*','(' ')*([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*)*)']')*)((' ')*','(' ')*([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*('['((([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*)((' ')*','(' ')*([A-Z]|[a-z]|[0-9]|'_')([A-Z]|[a-z]|[0-9]|'_'|'.')*)*)']')*)*)']')*);

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
WHITESPACE: [ \t]+ -> skip;
NEW_LINE: ('\r' '\n'? | '\n') -> skip;
BLOCK_COMMENT: '(*' .*? '*)'  -> channel(HIDDEN);
LINE_COMMENT:   '//' ~[\r\n]* -> channel(HIDDEN);
LINE_CONTINUATION : [ \t]+ '\r'? '\n' -> skip;
OTHER_CHARS : (~[\u0000-\u007F\uD800-\uDBFF\uDC00-\uDFFF]+) -> channel(2);

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
