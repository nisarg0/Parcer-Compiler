%{
    #include "y.tab.h"
    int x = 0;
%}

%%
"int"                               {x++;return INT;}
"float"                             {x++;return FLOAT;}
"char"                              {x++;return CHAR;}
"double"                            {x++;return DOUBLE;}
"exit"                              {x++;return EXIT;}
"{"                                 {return OPEN_PARA;}
"}"                                 {return CLOSE_PARA;}
"main"                              {return MAIN;}
"while"                             {return WHILE;}
"("                                 {return OPEN_BRA;}
")"                                 {return CLOSE_BRA;}
[a-zA-Z]+[a-zA-Z0-9_]*              {yylval.sIndex=yytext;if(x>0) {return ID;} return 0;}
","                                 {return C;}
";"                                 {x--;return SE;}
%%
