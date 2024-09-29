tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,t(8,nil,nil)),nil))).
%tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).
tree3(t(6, t(4,t(3,nil,nil),nil), t(9,nil,t(10,nil,nil)))).

inorder(t(K,L,R),List) :- inorder(L,LL),inorder(R,LR),append(LL,[K|LR],List).
inorder(nil,[]).

preorder(t(K,L,R),List) :- preorder(L,LL),preorder(R,LR),append([K|LL],LR,List).
preorder(nil,[]).

postorder(t(K,L,R),List) :- postorder(L,LL),postorder(R,LR),append(LL,LR,LP),append(LP,[K],List).
postorder(nil,[]).

pretty_print(nil,_).
pretty_print(t(K,L,R),D) :- D1 is D+1,pretty_print(L,D1),print_key(K,D),pretty_print(R,D1).

print_key(K,D) :- D>0,!,D1 is D-1,tab(8),print_key(K,D1).
print_key(K,_) :- write(K),nl.

pretty_print(T) :- pretty_print(T,0).

search_key(t(Key,_,_),Key) :- !.
search_key(t(K,L,_),Key) :- Key<K,!,search_key(L,Key).
search_key(t(_,_,R),Key) :- search_key(R,Key).

insert_key(Key,nil,t(Key,nil,nil)).
insert_key(Key,t(Key,L,R),t(Key,L,R)) :- !.
insert_key(Key,t(K,L,R),t(K,NL,R)) :- Key<K,!,insert_key(Key,L,NL).
insert_key(Key,t(K,L,R),t(K,L,NR)) :- insert_key(Key,R,NR).

delete_key(Key,t(Key,L,nil),L) :- !.
delete_key(Key,t(Key,nil,R),R) :- !.
delete_key(Key,t(Key,L,R),t(Pred,NL,R)) :- !,get_pred(L,Pred,NL).
delete_key(Key,t(K,L,R),t(K,NL,R)) :- Key<K,!,delete_key(Key,L,NL).
delete_key(Key,t(K,L,R),t(K,L,NR)) :- delete_key(Key,R,NR).

get_pred(t(Pred,L,nil),Pred,L) :- !.
get_pred(t(K,L,R),Pred,t(K,L,NR)) :- get_pred(R,Pred,NR).

max(A,B,A) :- A>B,!.
max(_,B,B).

height(nil,0).
height(t(_,L,R),H) :- height(L,H1),height(R,H2),max(H1,H2,HP),H is HP+1.

ternary_tree(
	t(6,
		t(4,
			t(2, nil, nil, nil),
			nil,
			t(7, nil, nil, nil)),
		t(5, nil, nil, nil),
		t(9,
			t(3, nil, nil, nil),
			nil,
			nil)
	)
).

pretty_print_ternary(nil,_).
pretty_print_ternary(t(K,L,M,R),D) :- D1 is D+1,print_key(K,D),pretty_print_ternary(L,D1),pretty_print_ternary(M,D1),pretty_print_ternary(R,D1).

pretty_print_ternary(T) :- pretty_print_ternary(T,0).

inorder_ternary(t(K,L,M,R),List) :- inorder_ternary(L,LL),inorder_ternary(M,LM),inorder_ternary(R,LR),append(LL,[K|LM],LP),append(LP,LR,List).
inorder_ternary(nil,[]).

preorder_ternary(t(K,L,M,R),List) :- preorder_ternary(L,LL),preorder_ternary(M,LM),preorder_ternary(R,LR),append([K|LL],LM,LP),append(LP,LR,List).
preorder_ternary(nil,[]).

postorder_ternary(t(K,L,M,R),List) :- postorder_ternary(L,LL),postorder_ternary(M,LM),postorder_ternary(R,LR),append(LL,LM,LP1),append(LP1,LR,LP2),append(LP2,[K],List).
postorder_ternary(nil,[]).

height_ternary(nil,0).
height_ternary(t(_,L,M,R),H) :- height_ternary(L,H1),height_ternary(M,H2),height_ternary(R,H3),max(H1,H2,HP1),max(HP1,H3,HP),H is HP + 1.

get_succ(t(Suc,nil,R),Suc,R) :- !.
get_succ(t(K,L,R),Suc,t(K,NL,R)) :- get_succ(L,Suc,NL).

delete_key_succ(Key,t(Key,L,nil),L) :- !.
delete_key_succ(Key,t(Key,nil,R),R) :- !.
delete_key_succ(Key,t(Key,L,R),t(Suc,L,NR)) :- !,get_succ(R,Suc,NR).
delete_key_succ(Key,t(K,L,R),t(K,NL,R)) :- Key<K,!,delete_key_succ(Key,L,NL).
delete_key_succ(Key,t(K,L,R),t(K,L,NR)) :- delete_key_succ(Key,R,NR).

leaf_list(nil,[]).
leaf_list(t(K,nil,nil),[K]).
leaf_list(t(_,L,R),Leafs) :- leaf_list(L,Leafs1),leaf_list(R,Leafs2),append(Leafs1,Leafs2,Leafs),!.

% Diametrul reprezinta distanta cea mai mare de la o frunza la o alta frunza
diam(nil,0).
diam(t(_,L,R),D) :- diam(L,DL),diam(R,DR),height(L,HL),height(R,HR),max(DL,DR,DP),HP is HL+HR+1,max(DP,HP,D).

same_depth(nil,_,[]).
same_depth(t(K,_,_),1,[K]) :- !.
same_depth(t(_,L,R),D,List) :- D1 is D-1, same_depth(L,D1,LP1),same_depth(R,D1,LP2),append(LP1,LP2,List).

internal_list(t(_,nil,nil),[]).
internal_list(t(K,L,R),[K|Nodes]) :- internal_list(L,LNodes),internal_list(R,RNodes),append(LNodes,RNodes,Nodes),!.
internal_list(t(K,L,nil),[K|Nodes]) :- internal_list(L,Nodes).
internal_list(t(K,nil,R),[K|Nodes]) :- internal_list(R,Nodes).

mirror(nil,nil).
mirror(t(_,L1,R1),t(_,L2,R2)) :- mirror(L1,R2),mirror(R1,L2).

symmetric(nil).
symmetric(t(_,L,R)) :- mirror(L,R).