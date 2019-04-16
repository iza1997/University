:- module(izabela_strumecka, [resolve/4, prove/2]).
:- op(200, fx, ~).
:- op(500, xfy, v).

change(X v Y, [X|L]):-
    change(Y,L),!.
change(X,[X]).


vars_bp(P,L):-
    vars_bp(P,L,[]).
vars_bp([],A,A).
vars_bp([H|T],L,A):-
    \+member(H,A),
    vars_bp(T,L,[H|A]),!.
vars_bp([H|T],L,A):-
    member(H,A),
    vars_bp(T,L,A).


por1(_,[],[]):-!.
por1(Z,[Z|T],R):-
    por1(Z,T,R).
por1(Z,[H|T],[H|R]):-
    por1(Z,T,R).


klauzula([],[]):-!.
klauzula([E],E):-!.
klauzula([H|T],H v R):-
    klauzula(T,R).




resolve(Z,C1,C2,R):-
    change(C1,L1),
    change(C2,L2),
    por1(Z,L1,R1),
    por1(~Z,L2,R2),
    append(R1,R2,L3),
    vars_bp(L3,L),
    klauzula(L,R),!.


overside_lists([],_):-!.
overside_lists([H|T],L):-
   member(H,L),!,
   overside_lists(T,L).


overside(C1,C2):-
    change(C1,L1),
    change(C2,L2),
    vars_bp(L1,LB1),
    vars_bp(L2,LB2),
    overside_lists(LB1,LB2).


oversideinlist([C1,_],[[H,_]|_]):-
   overside(H,C1),!.
oversideinlist([C1,_],[_|T]):-
    oversideinlist([C1,_],T).


formatowanie([],[]):-!.
formatowanie([H|T],[[H,axiom]|T1]):-
    formatowanie(T,T1).


dasie(Z,C1,C2):-
    change(C1,L1),
    change(C2,L2),
    member(Z,L1),
    member(~Z,L2),!.


dasie2(Z,[C1,_],[C2,_]):-
    dasie(Z,C1,C2);
    dasie(Z,C2,C1).


resolve2(Z,[C1,_],[C2,_],[R1,(Z,C1,C2)]):-
    dasie(Z,C1,C2),
    resolve(Z,C1,C2,R1),!.
resolve2(Z,[C1,_],[C2,_],[R1,(Z,C1,C2)]):-
    dasie(Z,C2,C1),
    resolve(Z,C2,C1,R1),!.


add_resolve(L,[R,X],P,L1):-
    \+ oversideinlist([R,_],L),
    \+ oversideinlist([R,_],P),
    append(L,[[R,X]],L1),!.
add_resolve(L,[R,_],_,L):-
    oversideinlist([R,_],L),!.
add_resolve(L,[R,_],P,L):-
    oversideinlist([R,_],P).


all_resolves1(Result,[],Result):-!.
all_resolves1([ActiveHead|ActiveTail],[PassiveHead|PassiveTail],Result):-
    dasie2(Z,ActiveHead,PassiveHead),
    resolve2(Z,ActiveHead,PassiveHead,R1),
    add_resolve([ActiveHead|ActiveTail],R1,[PassiveHead|PassiveTail],Active2),
    all_resolves1(Active2,PassiveTail,Result),!.
all_resolves1([ActiveHead|ActiveTail],[_|PassiveTail],Result):-
    all_resolves1([ActiveHead|ActiveTail],PassiveTail,Result).


all_resolves([Head|Set],Result):-
    all_resolves(Set,[Head],Result).
all_resolves([],Passive,Passive).
all_resolves([ActiveHead|ActiveTail],[PassiveHead|PassiveTail],Result):-
     all_resolves1([ActiveHead|ActiveTail],[PassiveHead|PassiveTail],[ActiveHead|R]),
     all_resolves(R,[ActiveHead|[PassiveHead|PassiveTail]],Result).


set_proof(Set,X,[[X,axiom]]):-
    member([X,axiom],Set),!.
set_proof(Set,C,Result):-
    member([C,(Z,X,Y)],Set),!,
    set_proof(Set,X,Result1),
    set_proof(Set,Y,Result2),
    append(Result1,[[C,(Z,X,Y)]],Result3),
    append(Result2,Result3,Result).


set_proof_bp(Set,C,Set_bp):-
    set_proof(Set,C,Result),
    vars_bp(Result,Set_bp).


numbers1(Set,Result):-
    numbers1(Set,1,[],Result).
numbers1([],_,A,A).
numbers1([[C,C1]|T],Count,A,Result):-
    Count1 is Count + 1,
    numbers1(T,Count1,[[C,C1,Count]|A],Result).


parents_one(Set,[X,(Z,X1,X2),N],[X,(Z,N1,N2),N]):-
    change(X1,L),
    member(Z,L),
    member([X1,_,N1],Set),!,
    member([X2,_,N2],Set),!.
parents_one(Set,[X,(Z,X1,X2),N],[X,(Z,N1,N2),N]):-
    member([X1,_,N2],Set),!,
    member([X2,_,N1],Set),!.



all_parents(Set,Result):-
    all_parents(Set,Set,Result,[]).
all_parents(_,[],A,A):-!.
all_parents(Set,[[H,axiom,N]|T],Result,A):-
    all_parents(Set,T,Result,[[H,axiom,N]|A]),!.
all_parents(Set,[[X,(Z,X1,X2),N]|T],Result,A):-
    parents_one(Set,[X,(Z,X1,X2),N],[X,(Z,N1,N2),N]),
    all_parents(Set,T,Result,[[X,(Z,N1,N2),N]|A]).

porzadek(Set,Result):-
    porzadek(Set,Result1,1,[]),
    reverse(Result1,Result).
porzadek([],A,_,A):-!.
porzadek(Set,Result,Count,A):-
    select([X,Y,Count],Set,Set2),!,
    Count2 is Count + 1,
    porzadek(Set2,Result,Count2,[(X,Y)|A]).




prove(Set,Proof):-
    formatowanie(Set,Set_format),
    all_resolves(Set_format,Result),
    member([[],_],Result),!,
    set_proof_bp(Result,[],Set_proof),
    reverse(Set_proof,Set_proof1),
    numbers1(Set_proof1,Set_numbers),
    all_parents(Set_numbers,Proof1),
    porzadek(Proof1,Proof).






















