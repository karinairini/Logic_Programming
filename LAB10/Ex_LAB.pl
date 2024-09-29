node(a).
node(b).
node(c).
node(d).

edge(a,b).
edge(b,a).
edge(a,d).
edge(d,a).
edge(b,c).
edge(c,b).
edge(b,d).
edge(d,b).
edge(c,d).
edge(d,c).

is_edge(X,Y) :- edge(X,Y),edge(Y,X).

c(X,[Y|P]) :- edge(X,Y), c(Y,X,[Y],P).
c(X,Y,PP,FP) :- edge(X,Z), \+member(Z,PP), c(Z,Y,[Z|PP],FP).
c(X,X,PP,P) :- reverse(PP,P).

:- dynamic neighbor/2.
neighbor(a,[b,d]).
neighbor(b,[a,c,d]).
neighbor(c,[b,d]).
neighbor(d,[a,b,c]).

:- dynamic gen_edge/2.

neighb_to_edge :-
	retract(neighbor(Node,List)),!,
	process(Node,List),
	neighb_to_edge.
neighb_to_edge.

process(Node,[H|T]) :- assertz(gen_edge(Node,H)),process(Node,T).
process(Node,[]) :- assertz(gen_node(Node)).

neighb_to_edge_v2 :-
	neighbor(Node,List),
	process(Node,List),
	fail.
neighb_to_edge_v2.

:- dynamic seen/1.
neighb_to_edge_v3 :-
	neighbor(Node,List),
	not(seen(Node)),!,
	assert(seen(Node)),
	process(Node,List),
	neighb_to_edge_v3.
neighb_to_edge_v3.

path(X,Y,Path) :- path(X,Y,[X],Path).

path(Y,Y,PPath,PPath).
path(X,Y,PPath,Path) :-
	edge(X,Z),
	not(member(Z,PPath)),!,
	path(Z,Y,[Z|PPath],Path).

restricted_path(X,Y,LR,Path) :-
	path(X,Y,Path),
	reverse(Path,RPath),
	check_restrictions(LR,RPath).
	
check_restrictions([],_) :- !.
check_restrictions([H|TR],[H|TP]) :- !,check_restrictions(TR,TP).
check_restrictions(LR,[_|TP]) :- check_restrictions(LR,TP).

:- dynamic sol_part/2.
optimal_path(X,Y,Path) :-
	asserta(sol_part([],100)),
	path(X,Y,[X],Path,1).
optimal_path(_,_,Path) :-
	retract(sol_part(Path,_)).

path(Y,Y,Path,Path,LPath) :-
	retract(sol_part(_,_)),!,
	asserta(sol_part(Path,LPath)),
	fail.
path(X,Y,PPath,Path,LPath) :-
	edge(X,Z),
	not(member(Z,PPath)),
	LPath1 is LPath+1,
	sol_part(_,Lopt),
	LPath1<Lopt,
	path(Z,Y,[Z|PPath],Path,LPath1).
	
% Problema 1
edge_ex1(a,b).
edge_ex1(b,c).
edge_ex1(a,c).
edge_ex1(c,d).
edge_ex1(b,d).
edge_ex1(d,e).
edge_ex1(e,a).

hamilton(NN,X,Path) :- NN1 is NN-1,hamilton_path(NN1,X,X,[X],Path).

hamilton_path(Len,NS,NF,PPath,Path) :- 
	Len>0,!,
	Len1 is Len-1, 
	edge_ex1(NS,New),
	not(member(New,PPath)),
	hamilton_path(Len1,New,NF,[New|PPath],Path).
hamilton_path(0,NS,NF,Path,[NF|Path]) :- 
	edge_ex1(NS,NF).
	
% Problema 2
edge_ex2(a,b).
edge_ex2(b,e).
edge_ex2(c,a).
edge_ex2(d,c).
edge_ex2(e,d).

euler(NE,S,R) :- euler(NE,S,[],R).
euler(0,_,R,R).
euler(NE,S,PR,R) :-
	NE>0,!,
	NE1 is NE-1,
	edge_ex2(S,New),
	not(member([S,New],PR)),
	euler(NE1,New,[[S,New]|PR],R).
	
% Problema 3
edge_ex3(a,b).
edge_ex3(a,c).
edge_ex3(c,e).
edge_ex3(e,a).
edge_ex3(b,d).
edge_ex3(d,a).

find_cycle(X,X,[X]) :- !.
find_cycle(X,Y,[X|R]) :- 
	edge_ex3(X,Z),
	find_cycle(Z,Y,R).
	
cycle(X,[X|R]) :- edge_ex3(X,Z),find_cycle(Z,X,R).

% Problema 4
neighb_ex4(a,[b,c]).
neighb_ex4(b,[d]).
neighb_ex4(c,[e]).
neighb_ex4(d,[a]).
neighb_ex4(e,[a]).

find_cycle_2(X,X,[X]) :- !.
find_cycle_2(X,Y,[X|R]) :- 
	neighb_ex4(X,L),
	member(H,L),
	find_cycle_2(H,Y,R).
	
cycle_neighb(X,[X|R]) :- neighb_ex4(X,L),member(H,L),find_cycle_2(H,X,R).

% Problema 5
edge_ex5(a,b).
edge_ex5(a,c).
edge_ex5(b,d).

:- dynamic gen_neighb_list/2.

edge_to_neighb :- 
	node(X),
	make_list(X),
	edge_ex5(X,Y),
	add_to_list(X,Y),
	fail.
edge_to_neighb.

make_list(X) :- assertz(gen_neighb_list(X,[])).

add_to_list(X,Y) :- retract(gen_neighb_list(X,L)),!,assertz(gen_neighb_list(X,[Y|L])).

% Problema 7
edge_ex7(a,c,7).
edge_ex7(a,b,10).
edge_ex7(c,d,1).
edge_ex7(b,e,1).
edge_ex7(d,e,2).

optimal_weighted_path(X,Y,Path) :-
	asserta(sol_part([],100)),
	path_weighted(X,Y,[X],Path,1).
optimal_weighted_path(_,_,Path) :-
	retract(sol_part(Path,_)).

path_weighted(Y,Y,Path,Path,LPath) :-
	retract(sol_part(_,_)),!,
	asserta(sol_part(Path,LPath)),
	fail.
path_weighted(X,Y,PPath,Path,LPath) :-
	edge_ex7(X,Z,L),
	not(member(Z,PPath)),
	LPath1 is LPath+L,
	sol_part(_,Lopt),
	LPath1<Lopt,
	path_weighted(Z,Y,[Z|PPath],Path,LPath1).