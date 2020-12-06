/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

% Se importa lo necesario de los otros archivos
% :- use_module(depth_first).
% :- use_module(hill_climbing).
% :- use_module(best_first).

% Para comodidad a la hora de desarrollar
clear :- write('\33\[2J').

% --------------------- Para visualizar árbol ------------------------------
rasmove(Z) :-
    between(0,Z,X),
    elmove(A,[1,2]),
    write(X), write(': '), write(A),nl.

elmove(X, Y) :- member(X,Y).
% --------------------------------------------------------------------------

solveDf(Estado,_,[]) :- finalState(_,Estado).

solveDf(Estado,Historia,[Movida|Movidas]) :-
    move(Estado,Movida,T),
    update(Estado,Movida,T,Estado2),
    not(member(Estado2,Historia)),
    solveDf(Estado2,[Estado2|Historia],Movidas).

solveDf(Caso,Movidas) :-
    initialState(Caso,Estado),
    solveDf(Estado,[Estado],Movidas).

% Tiempo que le toma a cada persona cruzar el puente
tiempo(a,1).
tiempo(b,2).
tiempo(c,5).
tiempo(d,10).
tiempo(e,15).
tiempo(j,20).

% estado(UbLinterna,MovidasPosibles,PersonasIzquierda,PersonasDerecha,TiempoTranscurrido, TiempoMaximo)
% en el estado inicial para cada caso, la linterna y todas las personas están a la izquierda
% del puente; no han cruzado. No hay nadie al otro lado del puente, y han transcurrido 0 minutos
initialState(caso1,estado(izq,2,[a,b,c,d,e],[],0,28)).
initialState(caso2,estado(izq,3,[a,b,c,d,e],[],0,21)).
initialState(caso3,estado(izq,2,[a,b,c,d,e,j],[],0,42)).
initialState(caso4,estado(izq,3,[a,b,c,d,e,j],[],0,30)).

% estado(UbLinterna,MovidasPosibles,PersonasIzquierda,PersonasDerecha,TiempoTranscurrido,TiempoMaximo)
% en el estado final de cada caso, la linterna está a la derecha y todas las personas
% están del otro lado; todos cruzaron. El tiempo transcurrido permitido es especificado
finalState(caso1,estado(der,2,[],[a,b,c,d,e],28,28)).
finalState(caso2,estado(der,3,[],[a,b,c,d,e],21,21)).
finalState(caso3,estado(der,2,[],[a,b,c,d,e,j],42,42)).
finalState(caso4,estado(der,3,[],[a,b,c,d,e,j],30,30)).

/*
Si la linterna está a la izquierda del puente y solo pueden cruzar dos personas a la vez
Se usa no-determinismo para generar todas las movidas posibles
*/
move(estado(der,_,_,D,Tt,Tm),[C1],Tt2) :-
    member(C1,D),
    tiempo(C1,X),
    Tt+X =< Tm,
    Tt2 is Tt+X.

move(estado(izq,2,I,_,Tt,Tm),Mov,Tt2) :-
    member(C1,I),
    member(C2,I),
    C1\=C2,
    tiempo(C1,X),
    tiempo(C2,Y),
    max_list([X,Y],Z),
    Tt+Z =< Tm,
    Tt2 is Tt+Z,
    sort([C1,C2],Mov).

move(estado(izq,3,[I1,I2],_,Tt,Tm),Mov,Tt2) :-
    tiempo(I1,X),
    tiempo(I2,Y),
    max_list([X,Y],Z),
    Tt+Z=<Tm,
    Tt2 is Tt+Z,
    sort([I1,I2],Mov).

move(estado(izq,3,I,_,Tt,Tm),Mov,Tt2) :-
    length(I,L),
    L>2,
    member(C1,I),
    member(C2,I), 
    member(C3,I),
    C1\=C2,
    C1\=C3,
    C2\=C3,
    tiempo(C1,W),
    tiempo(C2,X),
    tiempo(C3,Y),
    max_list([W,X,Y],Z),
    Tt+Z =< Tm,
    Tt2 is Tt+Z,
    sort([C1,C2,C3],Mov).


update(estado(izq,M,I,D,_,Tm),Mov,Tt2,estado(der,M,I2,D2,Tt2,Tm)) :-
    subtract(I,Mov,It),
    append(D,Mov,Dt),
    sort(It,I2),
    sort(Dt,D2).

update(estado(der,M,I,D,_,Tm),Mov,Tt2,estado(izq,M,I2,D2,Tt2,Tm)) :-
    append(I,Mov,It),
    subtract(D,Mov,Dt),
    sort(It,I2),
    sort(Dt,D2).

prueba(Estado,Estado2) :-
    move(Estado,Movida,T),
    update(Estado,Movida,T,Estado2).