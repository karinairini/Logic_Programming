edge(1,2).
edge(1,5).
edge(2,3).
edge(2,5).
edge(3,4).
edge(4,5).
edge(4,6).

is_edge(X,Y):- edge(X,Y);edge(Y,X).

edge_ex1(a,b).
edge_ex1(a,c).
edge_ex1(b,d).
edge_ex1(d,e).
edge_ex1(c,f).
edge_ex1(e,g).
edge_ex1(f,h).

is_edge_ex1(X,Y):- edge_ex1(X,Y);edge_ex1(Y,X).

:- dynamic nod_vizitat/1.


dfs(X,_) :- dfs_search(X).
dfs(_,L) :- !,collect_reverse([],L).

dfs_search(X) :-
	asserta(nod_vizitat(X)),
	%is_edge(X,Y),
	is_edge_ex1(X,Y),
	not(nod_vizitat(Y)),
	dfs_search(Y).
	
collect_reverse(L,P) :-
	retract(nod_vizitat(X)),!,
	collect_reverse([X|L],P).
collect_reverse(L,L).

:- dynamic coada/1.

bfs(X,_) :-
	assertz(nod_vizitat(X)),
	assertz(coada(X)),
	bfs_search.
bfs(_,L) :- !, collect_reverse([],L).

bfs_search :-
	retract(coada(X)),
	expand(X),!,
	bfs_search.
	
expand(X) :-
	is_edge(X,Y),
	not(nod_vizitat(Y)),
	asserta(nod_vizitat(Y)),
	assertz(coada(Y)),
	fail.
expand(_).

:- dynamic in_depth/1.

depth_max(2).

dls(X,_) :- depth_max(D),dls_search(X,D).
dls(_,L) :- !,collect_reverse([],L).

dls_search(X,D) :-
	D>=0,
	asserta(nod_vizitat(X)),
	asserta(in_depth(X)),
	is_edge_ex1(X,Y),
	not(nod_vizitat(Y)),
	D1 is D-1,
	dls_search(Y,D1).
	
neighbor(a,[b,c]).
neighbor(b,[a,d]).
neighbor(c,[a,e]).
neighbor(d,[b]).
neighbor(e,[c]).

bfs1(X,R) :-
	bfs1([X],[],P),
	reverse(P,R).
	
bfs1([],V,V).
bfs1([X|Q],V,R) :-
	\+member(X,V),
	neighbor(X,Ns),
	remove_visited(Ns,V,RemNs),
	append(Q,RemNs,NewQ),
	bfs1(NewQ,[X|V],R).
	
remove_visited([],_,[]).
remove_visited([H|T],V,[H|R]):- \+member(H,V),!,remove_visited(T,V,R).
remove_visited([_|T],V,R) :- remove_visited(T,V,R).
