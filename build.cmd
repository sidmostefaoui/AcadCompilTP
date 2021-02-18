@echo off

del lex.yy.c
del %1.tab.c
del %1.tab.h
del %1.tab.gch
del %1.exe

bison -d %1.y
flex %1.l

gcc lex.yy.c %1.tab.c -o %1



