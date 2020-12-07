/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

:- module(common,[initialState/2,finalState/2,move/3,update/4,clear/0]).

% Para comodidad a la hora de desarrollar
clear :- write('\33\[2J').

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
Regla auxiliar a move que obtiene, las posibles combinaciones de un tamaño determinado
para una lista. Dicho tamaño se logra siendo explícito con Comb
*/
possible(Arr,Comb) :-
    combs(Arr,Comb).

combs([],[]).

combs([X|Xs],[X|Xs2]) :-
    combs(Xs,Xs2).

combs([_|Xs],Xs2) :-
    combs(Xs,Xs2).

/*
Si la linterna está a la izquierda del puente y solo pueden cruzar dos personas a la vez
Se usa no-determinismo para generar todas las movidas posibles
*/
move(estado(der,_,_,D,Tt,Tm),[C1],Tt2) :-
    member(C1,D),
    tiempo(C1,X),
    Tt+X =< Tm,
    Tt2 is Tt+X.

move(estado(izq,2,I,_,Tt,Tm),[C1,C2],Tt2) :-
    possible(I,[C1,C2]),
    tiempo(C1,X), tiempo(C2,Y),
    max_list([X,Y],Z),
    Tt+Z =< Tm, Tt2 is Tt+Z.

move(estado(izq,3,[I1,I2],_,Tt,Tm),[I1,I2],Tt2) :-
    tiempo(I1,X), tiempo(I2,Y),
    max_list([X,Y],Z),
    Tt+Z=<Tm, Tt2 is Tt+Z.

move(estado(izq,3,I,_,Tt,Tm),[C1,C2,C3],Tt2) :-
    length(I,L), L>2,
    possible(I,[C1,C2,C3]),
    tiempo(C1,W), tiempo(C2,X), tiempo(C3,Y),
    max_list([W,X,Y],Z),
    Tt+Z =< Tm, Tt2 is Tt+Z.

/*
Hay dos casos de update, uno cuando la linterna está a la izquierda y otro cuando
la linterna está a la derecha.
*/
update(estado(izq,M,I,D,_,Tm),Mov,Tt2,estado(der,M,I2,D2,Tt2,Tm)) :-
    subtract(I,Mov,It),
    append(D,Mov,Dt),
    sort(It,I2), sort(Dt,D2).

update(estado(der,M,I,D,_,Tm),Mov,Tt2,estado(izq,M,I2,D2,Tt2,Tm)) :-
    append(I,Mov,It),
    subtract(D,Mov,Dt),
    sort(It,I2), sort(Dt,D2).