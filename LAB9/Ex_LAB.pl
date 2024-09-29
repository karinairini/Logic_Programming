add_dl(X,LS,LE,RS,RE) :- RS=LS,LE=[X|RE].

append_dl(LS1,LE1,LS2,LE2,RS,RE) :- RS=LS1,LE1=LS2,RE=LE2.

quicksort_dl([H|T],S,E) :- 
	partition(H,T,Sm,Lg),
	quicksort_dl(Sm,S,[H|L]),
	quicksort_dl(Lg,L,E).
quicksort_dl([],L,L).

partition(P,[X|T],[X|Sm],Lg) :- X<P,!,partition(P,T,Sm,Lg).
partition(P,[X|T],Sm,[X|Lg]) :- partition(P,T,Sm,Lg).
partition(_,[],[],[]).

inorder_dl(nil,L,L).
inorder_dl(t(K,L,R),LS,LE) :-
	inorder_dl(L,LSL,LEL),
	inorder_dl(R,LSR,LER),
	LS=LSL,LEL=[K|LSR],LE=LER.
	
inorder_dl_simplified(nil,L,L).
inorder_dl_simplified(t(K,L,R),LS,LE) :-
	inorder_dl_simplified(L,LS,[K|LT]),
	inorder_dl_simplified(R,LT,LE).
	
% Predicatele dinamice sunt folosite pentru a retine rezultate partiale in baza de cunostiinte. Ele se comporta ca un fel de caching,
% de exemplu in cazul predicatului Fibonacci.

convertCL2DL(L,LS,LE) :- append(L,LE,LS).

convertDL2CL(LS,LE,[]) :- LS==LE,!.
convertDL2CL([H|LS],LE,[H|L]) :- convertDL2CL(LS,LE,L).

convertIL2DL(L,LS,LE) :- append(L,LE,LS),!.

convertDL2IL(LS,LE,_) :- LS==LE,!.
convertDL2IL([H|LS],LE,[H|L]) :- convertDL2IL(LS,LE,L).

flat_dl([],RS,RS).
flat_dl([H|T],[H|RS],RE) :- atomic(H),!,flat_dl(T,RS,RE).
flat_dl([H|T],RS,RE) :- flat_dl(H,RS1,RE1),flat_dl(T,RS2,RE2),RS=RS1,RE1=RS2,RE=RE2.

all_decompositions(L,_) :-
	append(A,B,L),
	assert(p(A,B)),
	fail.
all_decompositions(_,List) :- collect_all(List).

collect_all([[A,B]|List]) :- retract(p(A,B)),!,collect_all(List).
collect_all([]).

complete_tree(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
incomplete_tree(t(6, t(4,t(2,_,_),t(5,_,_)), t(9,t(7,_,_),_))).

preorder_dl(nil,L,L).
preorder_dl(t(K,L,R),LS,LE) :-
	preorder_dl(L,LSL,LEL),
	preorder_dl(R,LSR,LER),
	LS=[K|LSL],LEL=LSR,LE=LER.

postorder_dl(nil,L,L).
postorder_dl(t(K,L,R),LS,LE) :-
	postorder_dl(L,LSL,LEL),
	postorder_dl(R,LSR,LER),
	LS=LSL,LEL=LSR,
	add_dl(K,LSR,LER,_,RER),
	LE=RER.

even_dl(nil, L, L).
even_dl(t(K, L, R), LS, LE) :-
	K mod 2 =:= 0,!,
    even_dl(L,LSL,LEL),
    even_dl(R,LSR,LER),
    LS=LSL,LEL=[K|LSR],LE=LER.
even_dl(t(_,L,R),LS,LE) :-
    even_dl(L,LSL,LEL),
    even_dl(R,LSR,LER),
    LS=LSL,LEL=LSR,LE=LER.

between_dl(T,L,L,_,_) :- var(T),!.
between_dl(t(K,L,R),LS,LE,K1,K2) :-
	K>K1,K<K2,!,
	between_dl(L,LSL,LEL,K1,K2),
	between_dl(R,LSR,LER,K1,K2),
	LS=LSL,LEL=[K|LSR],LE=LER.
between_dl(t(_,L,R),LS,LE,K1,K2) :-
	between_dl(L,LSL,LEL,K1,K2),
	between_dl(R,LSR,LER,K1,K2),
	LS=LSL,LEL=LSR,LE=LER.
	
collect_depth_k(T,_,L,L) :- var(T),!.
collect_depth_k(t(K,_,_),1,[K|L],L) :- !.
collect_depth_k(t(_,L,R),D,LS,LE) :-
    D1 is D-1,
    collect_depth_k(L,D1,LSL,LEL),
    collect_depth_k(R,D1,LSR,LER),
	LS=LSL,LEL=LSR,LE=LER.

% 1. Avem nevoie de retract_all inainte de apelul all_perm pentru a garanta că baza de cunoștințe este goală înainte de a adăuga rezultatele 
% predicatului perm. Astfel, vom putea colecta ulterior doar rezultatele de care avem nevoie, fără a exista ceva în plus.
% 2. Avem nevoie de ! dupa retract in predicatul collect_perms pentru a impiedica retract sa faca bactracking si pentru a nu scoate alte rezultate
% din baza de cunostiinte de care vom avea nevoie sa le colectam.
% 3. In predicatul collect_perms se face backtracking de tip backward. Nu se poate face backtracking de tip forward fara inca un argument.
% 4. Predicatul collect_perms distruge rezultatele salvate, adica le scoate din baza de cunostiinte.