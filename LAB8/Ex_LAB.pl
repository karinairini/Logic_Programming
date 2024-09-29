member_il(_,L) :- var(L),!,fail.
member_il(X,[X|_]) :- !.
member_il(X,[_|T]) :- member_il(X,T).

insert_il1(X,L) :- var(L),!,L=[X|_].
insert_il1(X,[X|_]) :- !.
insert_il1(X,[_|T]) :- insert_il1(X,T).

insert_il2(X,[X|_]) :- !.
insert_il2(X,[_|T]) :- insert_il2(X,T).

delete_il(_,L,L) :- var(L),!.
delete_il(X,[X|T],T) :- !.
delete_il(X,[H|T],[H|R]) :- delete_il(X,T,R).

search_it(_,T) :- var(T),!,fail.
search_it(Key,t(Key,_,_)) :- !.
search_it(Key,t(K,L,_)) :- Key<K,!,search_it(Key,L).
search_it(Key,t(_,_,R)) :- search_it(Key,R).

insert_it(Key,t(Key,_,_)) :- !.
insert_it(Key,t(K,L,_)) :- Key<K,!,insert_it(Key,L).
insert_it(Key,t(_,_,R)) :- insert_it(Key,R).

delete_it(_,T,T) :- var(T),!.
delete_it(Key,t(Key,L,R),L) :- var(R),!.
delete_it(Key,t(Key,L,R),R) :- var(L),!.
delete_it(Key,t(Key,L,R),t(Pred,NL,R)) :- !,get_pred(L,Pred,NL).
delete_it(Key,t(K,L,R),t(K,NL,R)) :- Key<K,!,delete_it(Key,L,NL).
delete_it(Key,t(K,L,R),t(K,L,NR)) :- delete_it(Key,R,NR).

get_pred(t(Pred,L,R),Pred,L) :- var(R),!.
get_pred(t(Key,L,R),Pred,t(Key,L,NR)) :- get_pred(R,Pred,NR).

convertIL2CL(L,[]) :- var(L),!.
convertIL2CL([H|T],[H|R]) :- convertIL2CL(T,R).

convertCL2IL([],_) :- !.
convertCL2IL([H|T],[H|R]) :- convertCL2IL(T,R).

append_il1(L1,L2,L2) :- var(L1),!.
append_il1([H|T],L2,[H|R]) :- append_il1(T,L2,R).

append_il2(L2,L2) :- !.
append_il2([_|T],L2) :- append_il2(T,L2).

reverse_il_fwd(L,Acc,Acc) :- var(L),!.
reverse_il_fwd([H|T],Acc,R) :- Acc1=[H|Acc],reverse_il_fwd(T,Acc1,R).
reverse_il_fwd(L,R) :- reverse_il_fwd(L,_,R).

reverse_il_bwd(L,L) :- var(L),!.
reverse_il_bwd([H|T],R) :- reverse_il_bwd(T,R),insert_il1(H,R).

flat_il(L,L) :- var(L),!.
flat_il([H|T],[H|R]) :- atomic(H),!,flat_il(T,R).
flat_il([H|T],R) :- flat_il(H,R),flat_il(T,R1),append_il2(R,R1).

incomplete_tree(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))).
complete_tree(t(7, t(5, t(3, nil, nil), t(6, nil, nil)), t(11, nil, nil))).

convertIT2CT(T,nil) :- var(T),!.
convertIT2CT(t(K,L,R),t(K,NL,NR)) :- convertIT2CT(L,NL),convertIT2CT(R,NR).

convertCT2IT(nil,_) :- !.
convertCT2IT(t(K,L,R),t(K,NL,NR)) :- convertCT2IT(L,NL),convertCT2IT(R,NR).

preorder_it(T,_) :- var(T),!.
preorder_it(t(K,L,R),List) :- preorder_it(L,LL),preorder_it(R,LR),append_il1([K|LL],LR,List).

max(A,B,A) :- A>B,!.
max(_,B,B).

height_it(T,0) :- var(T),!.
height_it(t(_,L,R),H) :- height_it(L,HL),height_it(R,HR),max(HL,HR,HP),H is HP+1.

diam_it(T,0) :- var(T),!.
diam_it(t(_,L,R),D) :- diam_it(L,DL),diam_it(R,DR),height_it(L,HL),height_it(R,HR),max(DL,DR,DP),HP is HL+HR+1,max(DP,HP,D).

isInList(T1,T2) :- var(T1),var(T2),!.
isInList([H|T1],[H|T2]) :- isInList(T1,T2).

subl_il(_,T) :- var(T),!,fail.
subl_il(SL,L) :- isInList(SL,L),!.
subl_il(SL,[_|T]) :- subl_il(SL,T).