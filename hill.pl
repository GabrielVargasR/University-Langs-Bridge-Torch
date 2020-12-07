/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

:- use_module(common).

hillClimber(State,_,[]) :-
    finalState(_,State).

hillClimber(State,History,[Move|Moves]) :-
    hillClimb(State,[Move,Time]),
    update(State,Move,Time,State2),
    not(member(State2,History)),
    hillClimber(State2,[State2|History],Moves).

hillClimber(Case,Moves) :-
    initialState(Case,State),
    hillClimber(State,[State],Moves).

hillClimb(State,Move) :-
    findall([M,T],move(State,M,T),Moves),
    evaluateAndOrder(Moves,State,[],MVs),
    member((Move,_),MVs).

evaluateAndOrder([[Move,Time]|Moves],State,MVs,OrderedMVs) :-
    update(State,Move,Time,State2),
    last(Move,X),
    common:tiempo(X,MoveTime),
    value(State2,MoveTime,Value),
    insertPair(([Move,Time],Value),MVs,MVs1),
    evaluateAndOrder(Moves,State,MVs1,OrderedMVs).

evaluateAndOrder([],_,MVs,MVs).

insertPair(MV,[],[MV]).
insertPair((M,V),[(M1,V1)|MVs],[(M,V),(M1,V1)|MVs]) :-
    V >= V1.
insertPair((M,V),[(M1,V1)|MVs],[(M1,V1)|MVs1]) :-
    V < V1,insertPair((M,V),MVs,MVs1).

value(estado(der,_,_,_,_,_),1,1).
value(estado(der,_,_,_,_,_),2,1).
value(estado(der,_,_,_,_,_),5,1).

value(estado(der,2,_,_,_,_),10,2).
value(estado(der,2,_,_,_,_),15,3).
value(estado(der,2,_,_,_,_),20,4).

value(estado(der,3,_,D,_,_),10,4) :- member(c,D).
value(estado(der,3,_,D,_,_),10,2) :- not(member(c,D)).
value(estado(der,3,_,D,_,_),15,6) :- member(d,D).
value(estado(der,3,_,D,_,_),15,3) :- not(member(d,D)).
value(estado(der,3,_,D,_,_),20,7) :- member(e,D).
value(estado(der,3,_,D,_,_),20,5) :- not(member(e,D)).

value(estado(izq,_,_,_,_,_),20,0).
value(estado(izq,_,_,_,_,_),15,0).
value(estado(izq,_,_,_,_,_),10,0).
value(estado(izq,_,_,_,_,_),5,1).
value(estado(izq,_,_,_,_,_),2,2).
value(estado(izq,_,_,_,_,_),1,3).