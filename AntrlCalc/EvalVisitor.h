#pragma once
#include "calc\LabeledExprBaseVisitor.h"
#include "calc\LabeledExprParser.h"
#include <map>

using namespace antlr4;
using namespace calc;
using namespace std;

class EvalVisitor :
    public LabeledExprBaseVisitor
{
    virtual antlrcpp::Any visitPrintExpr(LabeledExprParser::PrintExprContext* context);

    virtual antlrcpp::Any visitAssign(LabeledExprParser::AssignContext* context);

    virtual antlrcpp::Any visitParens(LabeledExprParser::ParensContext* context);

    virtual antlrcpp::Any visitMulDiv(LabeledExprParser::MulDivContext* context);

    virtual antlrcpp::Any visitAddSub(LabeledExprParser::AddSubContext* context);

    virtual antlrcpp::Any visitId(LabeledExprParser::IdContext* context);

    virtual antlrcpp::Any visitInt(LabeledExprParser::IntContext* context);

private:
    std::map<std::string, int> memory;
};

