rd /s /q .\AntrlCalc\calc
java -jar antlr4-4.8-1-complete.jar -Dlanguage=Cpp -no-listener -visitor -encoding UTF-8 -o .\AntrlCalc\calc -package calc LabeledExpr.g4
@pause