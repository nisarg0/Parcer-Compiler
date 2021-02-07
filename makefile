BT18CSE040: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o BT18CSE040

lex.yy.c: y.tab.c BT18CSE040.l
	lex BT18CSE040.l

y.tab.c: BT18CSE040.y
	yacc -d BT18CSE040.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h BT18CSE040 BT18CSE040.dSYM

