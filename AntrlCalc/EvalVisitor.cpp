#include "EvalVisitor.h"
#include "calc/LabeledExprParser.h"

antlrcpp::Any EvalVisitor::visitPrintExpr(LabeledExprParser::PrintExprContext* context)
{
    int i = visit(context->expr());
    std::cout << i << std::endl;
    return 0;
}

antlrcpp::Any EvalVisitor::visitAssign(LabeledExprParser::AssignContext* context)
{
    string id = context->ID()->getText(); // id is left-hand side of '='
    int value = visit(context->expr()); // compute valueof expression on right
    memory[id] = value; // store it inour memory
    return value;
}

antlrcpp::Any EvalVisitor::visitParens(LabeledExprParser::ParensContext* context)
{
    return visit(context->expr()); // return childexpr's value
}

antlrcpp::Any EvalVisitor::visitMulDiv(LabeledExprParser::MulDivContext* context)
{
    int left = visit(context->expr(0)); // get value of left subexpression
    int right = visit(context->expr(1)); // get value of right subexpression
    if (context->op->getType() == LabeledExprParser::MUL)
        return left * right;
    else
        return left / right; // must be DIV
}

antlrcpp::Any EvalVisitor::visitAddSub(LabeledExprParser::AddSubContext* context)
{
    int left = visit(context->expr(0)); // get value ofleft subexpression
    int right = visit(context->expr(1)); // get value ofright subexpression
    if (context->op->getType() == LabeledExprParser::ADD)
        return left + right;
    else
        return left - right; // must be SUB
}

antlrcpp::Any EvalVisitor::visitId(LabeledExprParser::IdContext* context)
{
    std::string id = context->ID()->getText();
    std::cout << id << std::endl;
    auto itFind = memory.find(id);
    if (itFind != memory.end())
        return (*itFind).second;
    return 0;
}

antlrcpp::Any EvalVisitor::visitInt(LabeledExprParser::IntContext* context)
{
    return atoi(context->INT()->getText().c_str());
}
