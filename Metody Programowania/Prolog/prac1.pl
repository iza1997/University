:- op(200, fx, ~).
:- op(500, xfy , v).

vars_zp(~X v Y, [X|L]):-
    vars(Y,L),!.
vars_zp(X v Y, [X|L]):-
    vars(Y,L),!.
vars_zp(~X,[X]):-!.
vars_zp(X,[X]).

vars_bp(P,L):-
    vars_bp(P,L,[]).
vars_bp([],A,A).
vars_bp([H|T],L,A):-
    \+member(H,A),
    vars_bp(T,L,[H|A]),!.
vars_bp([H|T],L,A):-
    member(H,A),
    vars_bp(T,L,A).

vars(X,L) :-
    vars_zp(X,L1),
    vars_bp(L1,L).

set_vars([],[]).
set_vars([X],L):-
    vars(X,L),!.
set_vars([H|T],L):-
    set_vars([H|T],L,[]).
set_vars([],L,A):-
    vars_bp(A,L).
set_vars([H|T],L,A):-
    vars(H,L1),
    append(L1,A,L2),
    set_vars(T,L,L2).

wartosciowanie([],[]).
wartosciowanie([H|T],[(H,t)|T1]) :- wartosciowanie(T,T1).
wartosciowanie([H|T],[(H,f)|T1]) :- wartosciowanie(T,T1).


spelnialna(~X,W):-member((X,f),W),!.
spelnialna(X,W) :- member((X,t),W).
spelnialna(X v _, W):- spelnialna(X,W),!.
spelnialna(_ v Y, W):-spelnialna(Y,W).

spelnialny([],_).
spelnialny([H|T],W):-
    spelnialna(H,W),
    spelnialny(T,W),!.

niespelnialny(L):-
    member(X,L),
    member(~X,L),!.

solve(Z,W):-
    \+member([],Z),
    \+niespelnialny(Z),
    set_vars(Z,V),
    wartosciowanie(V,W),
    spelnialny(Z,W).










