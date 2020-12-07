/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

:- use_module(common).

solveBest(Case,Moves) :-
    initialState(Case,State),
    % value(State,Value), porque el valor del initial es 0
    solveBest([point(State,[],1)],[State],Moves).

solveBest([point(State,Path,_)|_],_,Moves) :-
    finalState(_,State),
    reverse(Path,Moves).

solveBest([point(State,Path,_)|Frontier],History,FinalPath) :-
    findall([M,T],move(State,M,T),Moves),     % obtiene movidas del mejor estado
    updates(Moves,Path,State,States),   % obtiene los nuevos estados usando movidas
    % legals(States,States1),             % escoge los nuevos estados que son legales
    news(States,History,States2),      % elimina nuevos estados ya incluidos en historial
    evaluates(States2,Values),          % calcula valores heurísticos de los nuevos estados
    inserts(Values,Frontier,Frontier1), % inserta en orden los nuevos puntos en la frontera
    solveBest(Frontier1,[State|History],FinalPath). % continuar a partir de nueva frontera

updates([[Move,Time]|Moves],Path,State,[(State2,[Move|Path],MoveTime)|States]) :-
    last(Move,X),
    common:tiempo(X,MoveTime),
    update(State,Move,Time,State2),         % obtiene el estado al que se llega por una movida
    updates(Moves,Path,State,States).  % procesa recursivamente las siguientes movidas

updates([],_,_,[]).

% primer estado ya aparece en historial, excluirlo de la nueva lista
news([(S,_,_)|States],History,States1) :-
    member(S,History),
    news(States,History,States1).

% primer estado no aparece en historial, incluirlo en nueva lista
news([(S,P,T)|States],History,[(S,P,T)|States1]) :-
    not(member(S,History)),
    news(States,History,States1).
    
news([],_,[]).

evaluates([(S,P,T)|States],[point(S,P,V)|Values]) :-
    value(S,T,V),                % calcula valor heurístico del estado S
    evaluates(States,Values).  % procesa resto de estados

evaluates([],[]).

inserts([Point|Points],Frontier,Frontier1) :-
    insertPoint(Point,Frontier,Frontier0),  % inserta primer punto
    inserts(Points,Frontier0,Frontier1).    % recursivamente inserta los demás puntos
inserts([],Frontier,Frontier).

insertPoint(Point,[],[Point]).

insertPoint(Point,[Point1|Points],[Point1,Point|Points]) :-
    lessThan(Point1,Point).

insertPoint(Point,[Point1|Points],[Point|Points]) :-
    equals(Point,Point1).

insertPoint(Point,[Point1|Points],[Point1|Points1]) :-
    lessThan(Point,Point1),
    insertPoint(Point,Points,Points1).

insertPoint(Point,[Point1|Points],[Point,Point1|Points]) :-
    same(Point,Point1).

equals(point(S,_,V),point(S,_,V)).

lessThan(point(S1,_,V1),point(S2,_,V2)) :- S1 \= S2, V1 < V2.

same(point(S1,_,V1),point(S2,_,V2)) :- S1 \= S2, V1 = V2.