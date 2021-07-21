// AntrlCalc.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>
#include <string>
#include "ANTLRInputStream.h"
#include "calc/LabeledExprLexer.h"
#include "calc/LabeledExprParser.h"
#include "EvalVisitor.h"

using namespace std;
using namespace antlr4;
using namespace antlr4::tree;
using namespace calc;

char* read(const char* path) {
    FILE* fp;
#pragma warning(push)
#pragma warning(disable: 4996)
    if ((fp = fopen(path, "r")) == NULL) {
#pragma warning(pop)
        cout << "文件打开失败！" << endl;
    }

    fseek(fp, 0L, SEEK_END);
    int len = ftell(fp);
    rewind(fp);

    static char content[100];
    fread(content, 1, len, fp);
    fclose(fp);

    return content;
}

int main()
{
    string inputFile = ".\\x64\\Debug\\data.txt"; // .\\data.txt
    char* data = read(inputFile.c_str());

    string strData = data;
    ANTLRInputStream input(strData);
    LabeledExprLexer lexer(&input);

    // std::vector<std::unique_ptr<Token>> vt_tks;
    // vt_tks = lexer.getAllTokens();
    // 
    // for (auto it = vt_tks.begin(); it != vt_tks.end(); ++it)
    // {
    //     string strText = (*it)->getText();
    //     size_t stType = (*it)->getType();
    //     cout << strText << "\t" << stType << endl;
    // }

    CommonTokenStream tokens(&lexer);
    LabeledExprParser parser(&tokens);

    ParseTree* tree = parser.prog();
    // string strTree = tree->getText();
    // string strTree2 = tree->toStringTree(&parser);
    EvalVisitor eval;
    eval.visit(tree);
}
