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
 * create time: 2020-10-26
 * version: 1.0V
 */

parser grammar HolliAsSTVarParser;

options { tokenVocab=HolliAsSTVarLexer; }

var_prg
        : prg_type pou_name (COLON fun_return_type)?
          var_statementlist+ EOF
        ;

// POU类型（PROGRAMPRG, FUNCTION_BLOCK:FB, FUNCTION:FUN)
prg_type
        : PROGRAM 
        | FUNCTION_BLOCK 
        | FUNCTION
        ;

// 函数POU返回类型定义
fun_return_type
        : var_t_base
        | var_t_string
        | var_t_point
        ;

// pou Name
pou_name
        : NORMAL_IDENTIFIER
        ;

// 程序段：
//      局部变量定义段          l_var_statement
//      输入引脚定义段          i_var_statement
//      输入 & 输出引脚定义段   i_o_var_statement
//      输出引脚定义段          o_var_statement
var_statementlist
        : l_var_statement
        | i_var_statement
        | i_o_var_statement
        | o_var_statement
        ;

l_var_statement 
        : VAR 
                (var_list_statement)* 
          END_VAR
        ;

i_var_statement
        : VAR_INPUT
                (var_list_statement)* 
          END_VAR
        ;

i_o_var_statement
        : VAR_IN_OUT
                (var_list_statement)*
          END_VAR
        ;

o_var_statement
        : VAR_OUTPUT
                (var_list_statement)*
          END_VAR
        ;

// 变量定义列表
//  e.g. p3(2119): BOOL := FALSE;
//  e.g. p23(1093): POINTER TO ABD := 0;
//  e.g. in_p1(2119): ARRAY [0..3,0..2,0..3] OF INT := 48(0);
//  e.g. dd(2279): VIPA_2I2O := ( P_IN:=0, P_OUT:=0, IN0:=0); (*DPPA*)
//  e.g. p22(2119): HSEM277 := ( P_IN:=0, P_OUT:=0, ECARR:=2(TRUE), RET:=0 );
var_list_statement
        : var_name (LPAREN DEC_DIGIT RPAREN)? (var_als_name)?
                COLON  var_type_statement
                ASSIGN value_statement SEMI (var_desc)?;

// 变量描述
var_desc
        : BLOCK_COMMENT
        ;

// 变量别名
var_als_name
        : BLOCK_COMMENT
        ;

// 变量名称
var_name
        : NORMAL_IDENTIFIER
        ;

// 值定义
value_statement
        : const_value_item (COMMA const_value_item)*
        | LPAREN single_assign_exp (COMMA single_assign_exp)* RPAREN
        ;

const_value_item
        : const_value
        | DEC_DIGIT LPAREN const_value RPAREN
        ;

// 复核单体值定义
single_assign_exp
        : var_name ASSIGN value_statement
        ;

// 常量
const_value
        : HEX_DIGIT
        | (PLUS | MINUS)? DEC_DIGIT
        | OTC_DIGIT
        | BIN_DIGIT
        | CONST_XWD
        | CONST_BOOL        
        | CONST_XINT
        | CONST_DOUBLE

        | CONST_DATE
        | CONST_TIME
        | CONST_TIME_OF_DAY    
        | CONST_DATE_AND_TIME

        | CONST_STRING

        //枚举
        | NORMAL_IDENTIFIER
        ;

// 变量类型定义
var_type_statement
        : var_t_base
        | var_t_string
        | var_t_arr
        | var_t_point
        | var_t_udef
        ;

// 指针变量类型定义
// 【注】指针变量类型不能是指针类型
// e.g. POINTER TO BOOL
// e.g. POINTER TO HSEM277
// e.g. POINTER TO ARRAY[0..10,0..10,0..10] OF DATE
var_t_point
        : POINTER TO (
                var_t_base
                | var_t_string 
                | var_t_arr 
                | var_t_udef
          )
        ;

// 外部类型变量定义
var_t_udef
        : NORMAL_IDENTIFIER
        ;

// 数组变量类型定义 
//【注】数组只能是基础类型
// e.g. ARRAY [0..3,0..2,0..3] OF INT
var_t_arr
        : ARRAY
                (LBRACK arr_exp (COMMA arr_exp)* RBRACK)+ 
          OF 
                var_t_base
        ;

// 数组维度定义式
arr_exp
        : DEC_DIGIT RANGE DEC_DIGIT;

// 字符串类型变量定义 sting(len)
var_t_string
        : STRING LPAREN DEC_DIGIT RPAREN;

var_t_base
        : BOOL
        | BYTE
        | WORD
        | DWORD
        | SINT
        | USINT
        | INT
        | UINT
        | DINT
        | UDINT
        | TIME
        | DATE
        | TOD
        | DT
        | REAL
        | LREAL
        | BIT
        ;
