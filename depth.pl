/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

:- use_module(common).

/*
Regla principal del programa. solveDf/2 es la principal
Se indica el caso para el que se quiere obtener una solución,
Se obtiene o se verifica una solución a dicho caso. 
*/
solveDf(Estado,_,[]) :- finalState(_,Estado).

solveDf(Estado,Historia,[Movida|Movidas]) :-
    move(Estado,Movida,T),
    update(Estado,Movida,T,Estado2),
    not(member(Estado2,Historia)),
    solveDf(Estado2,[Estado2|Historia],Movidas).

solveDf(Caso,Movidas) :-
    initialState(Caso,Estado),
    solveDf(Estado,[Estado],Movidas).