/*
TP2 2020ii - Problema del puente y la linterna
Gabriel Vargas Rodríguez- 2018103129
*/

:- use_module(common).

solveBest(Case,Moves) :-
    iniialState(Case,State),
    % value(State,Value), porque el valor del initial es 0
    solveBest([point(State,[],0)],[State],Moves).

solveBest([point(State,Path,_)|_],_,Moves) :-
    final_state(State),reverse(Path,Moves).

solve_best([point(State,Path,_)|Frontier],History,FinalPath) :-
    findall([M,T],move(State,M,T),Moves),     % obtiene movidas del mejor estado
    updates(Moves,Path,State,States),   % obtiene los nuevos estados usando movidas
    % legals(States,States1),             % escoge los nuevos estados que son legales
    news(States1,History,States2),      % elimina nuevos estados ya incluidos en historial
    evaluates(States2,Values),          % calcula valores heurísticos de los nuevos estados
    inserts(Values,Frontier,Frontier1), % inserta en orden los nuevos puntos en la frontera
    solve_best(Frontier1,[State|History],FinalPath). % continuar a partir de nueva frontera

updates([[M,T]|Ms],Path,S,[(S1,[M|Path])|Ss]) :-
    update(S,M,T,TS1),         % obtiene el estado al que se llega por una movida
    updates(Ms,Path,S,Ss).  % procesa recursivamente las siguientes movidas

updates([],_,_,[]).

% primer estado ya aparece en historial, excluirlo de la nueva lista
news([(S,_)|States],History,States1) :-
    member(S,History),
    news(States,History,States1).

% primer estado no aparece en historial, incluirlo en nueva lista
news([(S,P)|States],History,[(S,P)|States1]) :-
    not(member(S,History)),
    news(States,History,States1).
    
news([],_,[]).

