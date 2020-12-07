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